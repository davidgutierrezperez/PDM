//
//  LiveActivityViewModel.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import Foundation
import CoreLocation

final class LiveActivityViewModel {
    var activity: Activity?
    
    private let activityRepository = ActivityRepository.shared
    private let lapRepository = LapRepository.shared
    private let routeRepository = ActivityRouteRepository.shared
    
    private(set) var status = ActivityStatus.NOT_INTIATED
    private let locationService = LocationService()
    
    private let lapManager = LapManager()
    private let notificationManager = NotificationManager.shared
    
    private let timerManager = ActivityTimerManager()
    var onTimerUpdate: ((TimeInterval) -> Void)?
    
    private(set) var currentPace: Double = 0

    
    init(){
        activity = Activity()
    }
    
    func startActivity(){
        locationService.requestLocationPermission()
        locationService.startUpdatingLocation()
        
        locationService.requestCity { [weak self] city in
            self?.activity?.location = city ?? "Desconocido"
        }
        
        updateActivityData()
        activateTimer()
        status = ActivityStatus.ACTIVE
    }
    
    func pauseActivity(){
        timerManager.stop()
        status = ActivityStatus.PAUSED
        locationService.disable()
    }
    
    func resumeActivity(){
        activateTimer()
        
        updateActivityData()
        status = ActivityStatus.ACTIVE
        locationService.enable()
    }
    
    func endActivity(){
        guard let activity = activity else { return }

        status = ActivityStatus.ENDED
        saveData()
    }
    
    func discardActivity(){
        activity = nil
        status = ActivityStatus.DISCARDED
    }
    
    private func saveData(){
        guard activity != nil, activity!.avaragePace != nil else { return }
        print("Ritmo medio: ", FormatHelper.formatPace(activity!.avaragePace!))
        activity!.avaragePace = PaceManager.getAvaragePaceForActivity(for: activity!)
        activity!.maxPace = lapManager.maxPace
        
        activityRepository.create(activity: activity!)
    }
    
    private func activateTimer(){
        timerManager.start()
    
        timerManager.onTick = { [weak self] duration in
            self?.activity?.duration = duration
            self?.onTimerUpdate?(duration)
        }
    }
    
    private func updateActivityData(){
        updateTotalDistance()
        updateLocationDataRelated()
    }

    
    private func updateTotalDistance(){
        locationService.onDistanceUpdate = { [weak self] distance in
            DispatchQueue.main.async {
                self?.activity?.distance = distance
            }
        }
    }
    
    private func updateLocationDataRelated(){
        var didStartFirstLap = false
        
        locationService.onLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            
            if !didStartFirstLap {
                self.lapManager.startFirstLap(at: location, time: Date())
                didStartFirstLap = true
            }
            
            DispatchQueue.main.async {
                self.updatePace(lastLocation: self.locationService.lastLocation!,
                                currentLocation: location,
                                timeLastLocation: self.locationService.lastTimeLocation!)
                self.checkIfLapIsCompleted(currentLocation: location)
                self.updateAltitudeData(currentLocation: location)
                self.updateRoute(currentLocation: location)
            }
        }
    }
    
    private func updateRoute(currentLocation: CLLocation){
        let currentCoordinate = currentLocation.coordinate
        
        let routePoint = RoutePoint(id: UUID(), latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude, timestamp: Date(), altitude: currentLocation.altitude, speed: activity?.avarageSpeed)
        
        activity?.route.points.append(routePoint)
    }
    
    private func updatePace(lastLocation: CLLocation, currentLocation: CLLocation, timeLastLocation: Date){
        currentPace =  PaceManager.checkForCurrentPace(lastLocation: (self.locationService.lastLocation!), currentLocation: currentLocation, timeLastLocation: (self.locationService.lastTimeLocation!))
    }
    
    private func checkIfLapIsCompleted(currentLocation: CLLocation){
        guard activity != nil else { return }
        
        if let lap = self.lapManager.checkForNewLap(currentLocation: currentLocation, currentTime: Date()){
            activity!.laps.append(lap)
            notificationManager.sendLapCompletedNotification(lap: lap)
        }
    }
    
    private func updateAltitudeData(currentLocation: CLLocation){
        guard activity != nil else { return }
        
        let currentAltitude = currentLocation.altitude
        
        if (currentAltitude > (activity?.maxAltitude)!){
            activity?.maxAltitude = currentAltitude
            
            let ascent = currentAltitude - (activity?.maxAltitude)!
            activity?.totalAscent! += ascent
        }
        
        if (currentAltitude < (activity?.minAltitude)!){
            activity?.minAltitude = currentAltitude
            
            let descent = currentAltitude - (activity?.minAltitude)!
            activity?.totalDescent! += descent
        }
    }
    
}
