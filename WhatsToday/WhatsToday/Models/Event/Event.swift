//
//  Event.swift
//  WhatsToday
//
//  Created by William Rush on 8/5/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

enum LengthType: Int, Codable {
    /// Years old
    case age
    /// Years
    case period
}

enum ReminderFrequency: Int, Codable {
    case yearly
    case monthly
}

struct Event: Codable {
    let title: String
    var iconName: String
    let date: Date
    var lengthType: LengthType
    var reminderFrequency: ReminderFrequency
}

extension Event: Equatable {
    
    /// Two Event values are considered equal if their title and date are equal.
    static func ==(_ lhs: Event, _ rhs: Event) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date
    }
}

extension Event {
    
    /// Find the next reminder event today or later.
    func nextReminder(using calendar: Calendar) -> Reminder {
        // Currently, the code is very similar between the cases, but once we add the third case they won't be quite as similar.
        switch reminderFrequency {
        case .yearly:
            let today = calendar.today
            let monthAndDay = calendar.dateComponents([.month, .day], from: date)
            let reminderDate = calendar.nextDateAtOr(after: today, matching: monthAndDay)!
            return Reminder(originalEvent: self, date: reminderDate)
            
        case .monthly:
            let today = calendar.today
            let day = calendar.dateComponents([.day], from: date)
            let reminderDate = calendar.nextDateAtOr(after: today, matching: day)!
            return Reminder(originalEvent: self, date: reminderDate)
        }
    }
}
