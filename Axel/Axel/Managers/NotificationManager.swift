//
//  NotificationManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init(){}
    
    public func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error al solicitar los permisos de notificación: \(error.localizedDescription)")
            } else {
                print("Permisos concedido: \(granted)")
            }
        }
    }
    
    public func sendLapCompletedNotification(lap: Lap){
        let contentNotification = UNMutableNotificationContent()
        contentNotification.title = "Vuelta completada"
        contentNotification.body = "Has completada la vuelta \(lap.index) en \(FormatHelper.formatTime(lap.duration ?? 0.0))"
        contentNotification.sound = .default
        
        let triggerNotification = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let requestNotification = UNNotificationRequest(identifier: UUID().uuidString, content: contentNotification, trigger: triggerNotification)
        
        UNUserNotificationCenter.current().add(requestNotification) { error in
            if let error = error {
                print("Error al enviar notificación: \(error.localizedDescription)")
            } else {
                print("Notificación enviada con éxito")
            }
        }
    }
}
