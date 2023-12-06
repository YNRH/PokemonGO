//
//  ViewController.swift
//  PokemonGo
//
//  Created by yrojas on 5/12/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ubicacion.delegate = self
        pokemons = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.delegate = self
            mapView.showsUserLocation = true
            ubicacion.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {(timer) in if let coord = self.ubicacion.location?.coordinate{
                let pin = MKPointAnnotation()
                pin.coordinate = coord
                
                let randomLat = (Double(arc4random_uniform(200))-100.0)/5000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/5000.0
                pin.coordinate.latitude += randomLat
                pin.coordinate.longitude += randomLon
                self.mapView.addAnnotation(pin)
            }})
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func centrarTapped(_ sender: Any) {
        
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contActualizaciones<1{
            let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region,animated: true)
            contActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
        //print("Ubicación actualizada")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            let pinview = MKAnnotationView(annotation:annotation,reuseIdentifier:nil)
            pinview.image = UIImage(named: "player")
            var frame = pinview.frame
            frame.size.height=50
            frame.size.width=50
            pinview.frame = frame
            return pinview
        }
        
        let pinview = MKAnnotationView(annotation:annotation,reuseIdentifier:nil)
        pinview.image = UIImage(named: "mew")
        var frame = pinview.frame
        frame.size.height=50
        frame.size.width=50
        pinview.frame = frame
        return pinview
    }

}

