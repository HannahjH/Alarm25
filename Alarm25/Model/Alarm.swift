//
//  Alarm.swift
//  Alarm25
//
//  Created by Hannah Hoff on 3/11/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

class Alarm: Equatable, Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
    
    init(fireDate: Date, name: String, enabled: Bool = true, uuid: String = UUID().uuidString){
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
        
    }
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}
