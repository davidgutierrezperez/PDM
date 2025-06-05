//
//  MapManager.swift
//  Axel
//
//  Created by David Gutierrez on 4/6/25.
//

import MapKit

final class RouteMapManager: NSObject {
    private var lapPoints: [CLLocationCoordinate2D] = []
    private var routePoints: [RoutePoint] = []
    
    private(set) var routeMap: MKMapView
    
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
    
    private func drawRoutePolyline(){
        let sortedPoints = routePoints.sorted { $0.timestamp < $1.timestamp }
        
        let coordinates = sortedPoints.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        routeMap.addOverlay(polyline)
    }
    
    private func zoomToFill(){
        let allCoords = lapPoints + routePoints.map {
            return CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        guard !allCoords.isEmpty else { return }
        
        let region = MKCoordinateRegion(center: allCoords.first!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        routeMap.setRegion(region, animated: true)
    }
    
    public func centerMap(on coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 50) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        routeMap.setRegion(coordinateRegion, animated: true)
    }
}

extension RouteMapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        guard routePoints.isEmpty && lapPoints.isEmpty else { return }
        
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            routeMap.setRegion(region, animated: true)
        }
    }
}
