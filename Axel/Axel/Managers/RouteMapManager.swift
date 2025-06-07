//
//  MapManager.swift
//  Axel
//
//  Created by David Gutierrez on 4/6/25.
//

import MapKit

/// Clase que gestiona la representación del mapa que muestra la ruta de la
/// actividad de un usuario.
final class RouteMapManager: NSObject {
    
    /// Coordenadas de los intervalos completados.
    private var lapPoints: [CLLocationCoordinate2D] = []
    
    /// Coordenadas de los puntos de la ruta obtenidos durante la actividad.
    private var routePoints: [RoutePoint] = []
    
    /// Mapa que mostrará la ruta de la actividad.
    private(set) var routeMap: MKMapView
    
    /// Constructor por defecto del manejador de mapas. Configura el mapa y
    /// añade los puntos de la actividad.
    /// - Parameters:
    ///   - activity: actividad del usuario.
    ///   - mapView: mapa que mostrará la ruta del usuario durante la actividad.
    init(activity: Activity, mapView: MKMapView){
        routePoints = activity.route.points
        routeMap = mapView
        routeMap.mapType = .satellite
        routeMap.showsUserLocation = true
        
        for lap in activity.laps {
            lapPoints.append(lap.endCoordinate)
        }
        
        super.init()
        
        routeMap.delegate = self
    }
    
    /// Renderiza en el mapa la ruta de la actividad del usuario.
    public func renderRoute(){
        addLapAnnotations()
        drawRoutePolyline()
        
        if lapPoints.isEmpty && routePoints.isEmpty {
            if let userCoordinate = routeMap.userLocation.location?.coordinate {
                centerMap(on: userCoordinate)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if let userCoordinate = self.routeMap.userLocation.location?.coordinate {
                        self.centerMap(on: userCoordinate)
                    }
                }
            }
        } else {
            routeMap.showsUserLocation = false
            zoomToFill()
        }
    }
    
    /// Añade al mapa los puntos de los intervalos de la actividad.
    private func addLapAnnotations(){
        let startPoint = routePoints.sorted { $0.timestamp < $1.timestamp }.first
        let startCoordinate = CLLocationCoordinate2D(latitude: startPoint!.latitude, longitude: startPoint!.longitude)
        
        let firstAnnotation = MKPointAnnotation()
        firstAnnotation.coordinate = startCoordinate
        firstAnnotation.title = "Inicio"
        
        routeMap.addAnnotation(firstAnnotation)
        
        for (index, coordinate) in lapPoints.enumerated() {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = String(index + 1)
            
            routeMap.addAnnotation(annotation)
        }
    }
    
    /// Dibuja en el mapa la ruta seguida por el usuario durante la actividad.
    private func drawRoutePolyline(){
        let sortedPoints = routePoints.sorted { $0.timestamp < $1.timestamp }
        
        let coordinates = sortedPoints.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        routeMap.addOverlay(polyline)
    }
    
    /// Realiza un zoom para mostrar correctamente la zona en la que el usuario ha llevado a cabo la actividad.
    private func zoomToFill(){
        let allCoords = lapPoints + routePoints.map {
            return CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        guard !allCoords.isEmpty else { return }
        
        let region = MKCoordinateRegion(center: allCoords.first!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        routeMap.setRegion(region, animated: true)
    }
    
    /// Centra el mapa en la zona en la que se ha llevado a cabo la actividad.
    /// - Parameters:
    ///   - coordinate: coordenadas centrales en las que se llevó la actividad.
    ///   - regionRadius: radio sobre el que se mostrará la zona en la que se realizó la actividad.
    public func centerMap(on coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 50) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        routeMap.setRegion(coordinateRegion, animated: true)
    }
}

/// Extensión que maneja el renderizado del mapa en pantalla.
extension RouteMapManager: MKMapViewDelegate {
    /// Renderiza la ruta del usuario en el mapa.
    /// - Parameters:
    ///   - mapView: mapa en el que se mostrará la ruta.
    ///   - overlay: capa que contendrá la ruta del usuario.
    /// - Returns: renderizador de rutas en el mapa.
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    /// Gestiona los eventos que ocurren cuando el mapa se ha terminado de cargar. Centra el mapa en la región
    /// en la que se ha llevado a cabo la actividad del usuario.
    /// - Parameter mapView: mapa en el que se mostrará la ruta de la actividad.
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        guard routePoints.isEmpty && lapPoints.isEmpty else { return }
        
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            routeMap.setRegion(region, animated: true)
        }
    }
}
