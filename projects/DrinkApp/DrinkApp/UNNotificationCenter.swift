//
//  UNNotificationCenter.swift
//  DrinkApp
//
//  Created by seob_jj on 2021/10/05.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter{
    func addNotificationRequest(by alert: Alert){
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요"
        content.body = "세계보건기주(WHO)가 권장하는 하루 물 섭취량은 1.5L ~ 2L 입니다."
        content.sound = .default
        content.badge = 1
        
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
