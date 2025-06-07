//
//  LocationService.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import CoreLocation

/// Clase que gestiona el servicio de localización del usuario.
final class LocationService: NSObject {
    
    /// Objeto que maneja las acciones de localización del usuario.
    private let locationManager = CLLocationManager()
    
    /// Closure que permite obtener la información asociada a la actualización
    /// de la ubicación del usuario.
    private var completition: ((String?) -> Void)?
    
    /// Última ubicación del usuario.
    private(set) var lastLocation: CLLocation?
    
    /// Fecha de la última ubicación del usuario.
    private(set) var lastTimeLocation: Date?
    
    /// Distancia total recorrida desde el inicio de la actividad.
    private var totalDistance: CLLocationDistance = 0
    
    /// Closure que permite obtener información actualizada sobre la distancia
    /// recorrida por el usuario.
    var onDistanceUpdate: ((CLLocationDistance) -> Void)?
    
    /// Closure que permite obtener información actualizada sobre la
    /// ubicación actual del usuario.
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    /// Indica si el servicio de localización está activo.
    private var isActive: Bool = true
    
    /// Constructor por defecto del servicio de localización. Configura el manejador
    /// de localización y el tipo de actividad que registra.
    override init() {
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
    }
    
    /// Solicita autorización del usuario para poder obtener su ubicación.
    func requestLocationPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Inicia el servicio de localización del usuario.
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    /// Permite obtener la ciudad en la que se encuentra el usuario.
    /// - Parameter completition: acción a realizar al obtener la ubicación del usuario.
    func requestCity(completition: @escaping (String?) -> Void){
        requestLocationPermission()
        locationManager.requestLocation()
        self.completition = completition
    }
    
    /// Activa el servicio de localización.
    func enable(){
        isActive = true
    }
    
    /// Desactiva el servicio de localización.
    func disable(){
        isActive = false
    }
}

/// Extensión que maneja el servicio de localización del usuario.
extension LocationService: CLLocationManagerDelegate {
    
    /// Gestiona los eventos relacionados con la actualización de la ubicación del usuario.
    /// - Parameters:
    ///   - manager: manejador de localización del usuario.
    ///   - locations: array con información de la ubicación del usuario.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isActive else { return }
        guard let cityLocation = locations.first else {
            completition?(nil)
            return
        }
        
        guard let newLocation = locations.last else { return }
        
        if let last = lastLocation {
            let distance = newLocation.distance(from: last)
            totalDistance += distance
            onDistanceUpdate?(totalDistance)
        }
        
        lastLocation = newLocation
        lastTimeLocation = Date()
        
        onLocationUpdate?(newLocation)
        
        if let completition = completition {
            CLGeocoder().reverseGeocodeLocation(cityLocation) { placemarks, _ in
                let city = placemarks?.first?.locality
                completition(city)
                self.completition = nil
            }
        }
    }
    
    /// Gestiona los eventos de error al obtener la localización del usuario.
    /// - Parameters:
    ///   - manager: manejador de localización del usuario.
    ///   - error: error provocado.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error de localización: \(error.localizedDescription)")
            
            if let completition = completition {
                completition(nil)
                self.completition = nil
            }
        }
    
}
