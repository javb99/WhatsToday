//
//  CalendarCalculator.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/6/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

extension Calendar {
    /// Trims off any components that aren't contained in `components`.
    func date(keeping components: Set<Calendar.Component>, of date: Date) -> Date {
        return self.date(from: dateComponents(components, from: date))!
    }
    
    /// Today trimmed to only contain year, month, and day.
    var today: Date {
        return date(keeping: [.year, .month, .day], of: Date())
    }
}

enum Granularity {
    case yearly
}

struct CalendarCalculator {
    
    var calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale.autoupdatingCurrent
        return c
    }()
    
    /// Find the next reminder event today or later.
    func nextNotableAnniversary(of event: Event, granularity: Granularity) -> Anniversary {
        switch granularity {
        case .yearly:
            let today = calendar.date(keeping: [.year, .month, .day], of: Date())
            let monthAndDay = calendar.dateComponents([.month, .day], from: event.date)
            // Subtract 1 second from today to make the search behave as a >= today search.
            let anniversaryDate = calendar.nextDate(after: today-1, matching: monthAndDay, matchingPolicy: Calendar.MatchingPolicy.strict)!
            return Anniversary(originalEvent: event, date: anniversaryDate)
        }
    }
    
    func daysBetween(_ start: Date, _ end: Date) -> Int {
        return calendar.dateComponents([.day], from: start, to: end).day!
    }
    
    func yearsBetween(_ start: Date, _ end: Date) -> Int {
        return calendar.dateComponents([.year], from: start, to: end).year!
    }
    
    func yearsAndMonthsBetween(_ start: Date, _ end: Date) -> (years: Int, months: Int) {
        let components = calendar.dateComponents([.year, .month], from: start, to: end)
        return (years: components.year!, months: components.month!)
    }
}
