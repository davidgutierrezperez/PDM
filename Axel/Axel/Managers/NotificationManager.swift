//
//  NotificationManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import UserNotifications

/// Clase que gestiona el envio de notificaciones al usuario tras haber completado
/// un intervalo. Es un singleton.
final class NotificationManager {
    
    /// Instancia única de la clase
    static let shared = NotificationManager()
    
    /// Constructor por defecto de la clase. Dado que la clase es
    /// un singleton, no se permite instanciar objetos de la clase.
    private init(){}
    
    /// Solicita al usuario autorización para poder enviar notificaciones.
    public func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error al solicitar los permisos de notificación: \(error.localizedDescription)")
            } else {
                print("Permisos concedido: \(granted)")
            }
        }
    }
    
    /// Envia una notificación al usuario tras haber completado un intervalo.
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
