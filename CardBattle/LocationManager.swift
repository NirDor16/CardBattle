import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    static let midLongitude: Double = 34.817549168324334

    var onLocationReceived: ((CLLocation) -> Void)?
    var onLocationError: ((Error?) -> Void)?

    private let clManager = CLLocationManager()
    private override init() {
        super.init()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() {
        #if targetEnvironment(simulator)
        let mock = CLLocation(latitude: 31.7683, longitude: 35.2137)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.onLocationReceived?(mock)
        }
        #else
        let status = clManager.authorizationStatus
        if status == .notDetermined {
            clManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            clManager.requestLocation()
        } else {
            onLocationError?(nil)
        }
        #endif
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus == .denied ||
                  manager.authorizationStatus == .restricted {
            onLocationError?(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        onLocationReceived?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
    }
}
