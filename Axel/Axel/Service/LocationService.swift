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
    
    private var isActive: Bool = true
    
    override init() {
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
    }
    
    func requestLocationPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    func requestCity(completition: @escaping (String?) -> Void){
        requestLocationPermission()
        locationManager.requestLocation()
        self.completition = completition
    }
    
    func enable(){
        isActive = true
    }
    
    func disable(){
        isActive = false
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isActive else { return }
        guard let cityLocation = locations.first else {
            completition?(nil)
            return
        }
        
        guard let newLocation = locations.last else { return }
        
        onLocationUpdate?(newLocation)
        
        if let completition = completition {
            CLGeocoder().reverseGeocodeLocation(cityLocation) { placemarks, _ in
                let city = placemarks?.first?.locality
                completition(city)
                self.completition = nil
            }
        }
        
        if let last = lastLocation {
            let distance = newLocation.distance(from: last)
            totalDistance += distance
            onDistanceUpdate?(totalDistance)
            print("La distancia total es: ", totalDistance)
        }
        
        lastLocation = newLocation
        lastTimeLocation = Date()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error de localización: \(error.localizedDescription)")
            
            if let completition = completition {
                completition(nil)
                self.completition = nil
            }
        }
    
}
