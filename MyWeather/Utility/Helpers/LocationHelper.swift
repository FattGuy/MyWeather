import CoreLocation

protocol LocationHelperDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
}

class LocationHelper: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    weak var delegate: LocationHelperDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation != nil {
            self.stopLocationUpdating()
        } else {
            guard let location = locations.last else { return }
            let mockLocation = CLLocation(latitude: 44.34, longitude: 10.99)
            currentLocation = mockLocation
            delegate?.didUpdateLocation(mockLocation)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
