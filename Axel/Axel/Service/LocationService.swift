//
//  LocationService.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import CoreLocation

final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completition: ((String?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestCity(completition: @escaping (String?) -> Void){
        self.completition = completition
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            completition?(nil)
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            let city = placemarks?.first?.locality
            self.completition?(city)
            self.locationManager.stopUpdatingLocation()
        }
    }
}
