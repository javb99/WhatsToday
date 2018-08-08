//
//  CalendarCalculator.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/6/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

enum Granularity {
    case yearly
}

struct CalendarCalculator {
    
    var calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale.autoupdatingCurrent
        return c
    }()
    
    func nextNotableAnniversary(of event: Event, granularity: Granularity) -> Anniversary {
        switch granularity {
        case .yearly:
            let monthAndDay = calendar.dateComponents([.month, .day], from: event.date)
            let anniversaryDate = calendar.nextDate(after: Date(), matching: monthAndDay, matchingPolicy: Calendar.MatchingPolicy.strict)!
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
