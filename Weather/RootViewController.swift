//
//  ViewController.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import UIKit
import MapKit

class RootViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedCoordinates: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
            self.selectedCoordinates = coordinates

            performSegue(withIdentifier: "mapClick", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapClick" {
            if let weatherViewController = segue.destination as? WeatherViewController {
                weatherViewController.receivedCoordinates = self.selectedCoordinates
            }
        }
    }
}

