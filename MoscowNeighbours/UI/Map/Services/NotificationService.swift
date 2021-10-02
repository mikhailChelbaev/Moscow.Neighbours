//
//  NotificationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.10.2021.
//

import UserNotifications

final class NotificationService: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    private var notificationCompletion: Action?
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                Logger.log("User has declined notifications")
            }
        }
    }
    
    func fireNotification(title: String, notificationCompletion: Action?) {
        self.notificationCompletion = notificationCompletion
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Вы можете начать свое знакомство с героем"
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
        
        notificationCenter.add(request) { err in
            if let err = err { Logger.log(err.localizedDescription) }
        }
    }
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationCompletion?()
        completionHandler()
    }
    
}


