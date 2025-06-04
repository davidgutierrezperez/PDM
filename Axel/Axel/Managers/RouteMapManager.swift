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
        
        for lap in activity.laps {
            lapPoints.append(lap.endCoordinate)
        }
    }
    
    public func renderRoute(){
        addLapAnnotations()
        drawRoutePolyline()
        zoomToFill()
        
        routeMap.delegate = self
    }
    
    private func addLapAnnotations(){
        for (index, coordinate) in lapPoints.enumerated() {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = String(index)
            
            routeMap.addAnnotation(annotation)
        }
    }
    
    private func drawRoutePolyline(){
        let coordinates = routePoints.map {
            return MKMapPoint(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }
        
        let polyline = MKPolyline(points: coordinates, count: coordinates.count)
        
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
}
