//
//  AlarmController.swift
//  Alarm25
//
//  Created by Hannah Hoff on 3/11/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    static let shared = AlarmController()
    
    var alarms = [Alarm]()
    
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarm.enabled = enabled
        AlarmController.shared.alarms.append(alarm)
        
        
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        
        saveToPersistentStore()
        
    }
    
    func delete(alarm: Alarm){
        guard let index = AlarmController.shared.alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    
    func fileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = path[0]
        let fileName = "alarm.json"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        
        let endcoder = JSONEncoder()
        
        do{
            let data = try endcoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("Failed to save to persistent store \(error) ; \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Alarm] {
        
        let decoder = JSONDecoder()
        
        do{
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("Failed to load from persistent store \(error) ; \(error.localizedDescription)")
        }
        return []
    }
}

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Time to get up"
        content.body = "Your alarm named \(alarm.name) is going off!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
