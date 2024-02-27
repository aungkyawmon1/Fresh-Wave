//
//  ChooseAddressOnMapVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import UIKit
import MapKit

class ChooseAddressOnMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }

}

extension ChooseAddressOnMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
           
           let geocoder = CLGeocoder()
           let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           
           geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
               if let error = error {
                   print("Reverse geocoding failed: \(error.localizedDescription)")
                   return
               }
               
               if let placemark = placemarks?.first {
                   let address = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.country].compactMap { $0 }.joined(separator: ", ")
                   print("Address: \(address)")
                   // Here you can update the UI to display the address or do something else with it.
               }
           })
    }

}

extension ChooseAddressOnMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
