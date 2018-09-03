//
//  Event.swift
//  WhatsToday
//
//  Created by William Rush on 8/5/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public enum LengthType: Int, Codable {
    /// Years old
    case age
    /// Years
    case period
}

public enum ReminderFrequency: Int, Codable {
    case yearly
    case monthly
}

public struct Event: Codable, Equatable {
    public let title: String
    public var iconName: String
    public let date: Date
    public var lengthType: LengthType
    public var reminderFrequency: ReminderFrequency
}

public extension Event {
    
    /// Two Event values are considered equal if their title and date are equal.
    public static func ==(_ lhs: Event, _ rhs: Event) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date
    }
}

public extension Event {
    
    /// Find the next reminder event today or later.
    public func nextReminder(using calendar: Calendar) -> Reminder {
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
