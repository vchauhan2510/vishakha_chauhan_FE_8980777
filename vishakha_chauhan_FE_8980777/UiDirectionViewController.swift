import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var polyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        mapView.delegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        // Optionally, you can update the map view with the user's location here.
    }
    
    func getDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first, let polyline = route.polyline else {
                print("Error: No route found")
                return
            }
            self.mapView.addOverlay(polyline)
            self.mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
    
    // Example function to set start and end points and get directions
    func setStartAndEndPoints(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays) // Remove previous routes
        
        // Optionally, you can add start and end point annotations here.
        
        getDirections(from: startCoordinate, to: endCoordinate)
    }
}

