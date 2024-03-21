//
//  ChooseAddressOnMapVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import UIKit
import MapKit
import CoreLocation

protocol ChooseAddressOnMapDelegate: AnyObject {
    func chooseAddress(addressPlace: String, latitude: Double, longitude: Double)
}

class ChooseAddressOnMapVC: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var isAddressChoose: Bool = false
    private var addressPlace: String = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    weak var delegate: ChooseAddressOnMapDelegate?
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add tap gesture recognizer to the map view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(gestureRecognizer:)))
        tapRecognizer.delegate = self
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
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
    
    

    override func setupUI() {
        title = "Choose Address"
        let chooseButton : UIBarButtonItem = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(onClickChooseButton))

        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onClickCancelButton))

        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = chooseButton
    }
    
    @objc func onClickChooseButton() {
        if isAddressChoose {
            delegate?.chooseAddress(addressPlace: addressPlace, latitude: latitude, longitude: longitude)
            dismiss(animated: true)
        }
        
    }
    
    @objc func onClickCancelButton() {
        dismiss(animated: true)
    }
    
    // Function to add an annotation and reverse geocode the location
       @objc func handleMapTap(gestureRecognizer: UIGestureRecognizer) {
           print("gesture not began")
         //  if gestureRecognizer.state != .began { return } // Avoid multiple detections
           print("gesture began")
           let touchPoint = gestureRecognizer.location(in: mapView)
           let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
           print("Remove")
           // Remove existing annotations
           mapView.removeAnnotations(mapView.annotations)
           
           // Add new annotation
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
           mapView.addAnnotation(annotation)
           
           // Reverse geocoding
           let geocoder = CLGeocoder()
           let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           self.latitude = coordinate.latitude
           self.longitude = coordinate.longitude
           geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
               guard let self = self else { return }
               if let error = error {
                   print("Reverse geocoding failed: \(error)")
                   return
               }
               if let placemarks = placemarks, let placemark = placemarks.first {
                   self.isAddressChoose = true
                   self.addressPlace = "\(placemark.name ?? "") - \(placemark.country ?? "")"
                   print("Address: \(String(describing: placemark))")
                   
                   // Update annotation title with placemark information if needed
                   annotation.title = placemark.name
                   // You can also save these details for the "Choose" button action
               }
           }
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

extension ChooseAddressOnMapVC: CLLocationManagerDelegate, UIGestureRecognizerDelegate {
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    } 
}
