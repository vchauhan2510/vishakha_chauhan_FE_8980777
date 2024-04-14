//
//  ViewController.swift
//  MapsDemoSec4
//
//  Created by admin on 2024-03-04.
//

import UIKit
import CoreLocation
import MapKit

class mypageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()


    @IBOutlet weak var getDirectoionData: UITextField!
    @IBAction func getDirections(_ sender: Any) {
        convertAddress()
    }
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.delegate = self
    }
    
    func convertAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(getDirectoionData.text!) {
            (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else {
                print("Error with location")
                return
            }
            print(location)
            self.mapThis(desiredLocation: location.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay )
        routeline.strokeColor = .blue
        return routeline
    }
    
    func mapThis(desiredLocation: CLLocationCoordinate2D) {
        let sourceCoordinate = (manager.location?.coordinate)!
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: desiredLocation)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { response,error in
            guard let response = response else {
                if let error = error {
                    print("There's an error")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: desiredLocation.latitude, longitude: desiredLocation.longitude)
            pin.coordinate = coordinate
            pin.title = "END POINT"
            self.mapView.addAnnotation(pin)
        }
        
    }
    
    
    

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let locations = locations.first {
//            manager.startUpdatingLocation()
//            render(locations)
//        }
//    }
//
//    func render(_ location: CLLocation) {
//        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        mapView.addAnnotation(pin)
//        mapView.setRegion(region, animated: true)
//    }

}


