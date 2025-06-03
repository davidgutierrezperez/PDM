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
    
    private(set) var lastLocation: CLLocation?
    private(set) var lastTimeLocation: Date?
    private var totalDistance: CLLocationDistance = 0
    
    var onDistanceUpdate: ((CLLocationDistance) -> Void)?
    var onLocationUpdate: ((CLLocation) -> Void)?
    
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
        guard let cityLocation = locations.first else {
            completition?(nil)
            return
        }
        
        guard let newLocation = locations.last else { return }
        
        onLocationUpdate?(newLocation)
        
        CLGeocoder().reverseGeocodeLocation(cityLocation) { placemarks, _ in
            let city = placemarks?.first?.locality
            self.completition?(city)
            self.locationManager.stopUpdatingLocation()
        }
        
        if let last = lastLocation {
            let distance = newLocation.distance(from: last)
            totalDistance += distance
            onDistanceUpdate?(totalDistance)
        }
        
        lastLocation = newLocation
        lastTimeLocation = Date()
    }
    
}
