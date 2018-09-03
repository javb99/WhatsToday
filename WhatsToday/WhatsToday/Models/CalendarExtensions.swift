//
//  CalendarCalculator.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/6/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public extension Calendar {
    
    /// Trims off any components that aren't contained in `components`.
    public func date(keeping components: Set<Calendar.Component>, of date: Date) -> Date {
        return self.date(from: dateComponents(components, from: date))!
    }
    
    /// Today trimmed to only contain year, month, and day.
    public var today: Date {
        return date(keeping: [.year, .month, .day], of: Date())
    }
    
    /// The number of days from today til the given date.
    public func daysAway(from date: Date) -> Int {
        return daysBetween(today, date)
    }
    
    /// The number of days from `start` to `end`. It is common to use dates that have the smaller units removed.
    public func daysBetween(_ start: Date, _ end: Date) -> Int {
        return dateComponents([.day], from: start, to: end).day!
    }
    
    /// The number of years from `start` to `end`. It is common to use dates that have the smaller units removed.
    public func yearsBetween(_ start: Date, _ end: Date) -> Int {
        return dateComponents([.year], from: start, to: end).year!
    }
    
    /// The number of years and remainder months from `start` to `end`. It is common to use dates that have the smaller units removed.
    public func yearsAndMonthsBetween(_ start: Date, _ end: Date) -> (years: Int, months: Int) {
        let components = dateComponents([.year, .month], from: start, to: end)
        return (years: components.year!, months: components.month!)
    }
    
    /// Subtract 1 second from today to make the search behave as a >= today search.
    public func nextDateAtOr(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy = .strict) -> Date? {
        return self.nextDate(after: date-1, matching: components, matchingPolicy: matchingPolicy)
    }
}
