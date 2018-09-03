//
//  CalendarCalculator.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/6/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

public extension Calendar {
    
    /// Today trimmed to only contain year, month, and day.
    public var today: Date {
        return startOfDay(for: Date())
    }
    
    /// The number of days from today til the given date.
    public func daysAway(from date: Date) -> Int {
        return daysBetween(today, date)
    }
    
    /// The number of days from `start` to `end`. Ignores units smaller than day.
    public func daysBetween(_ start: Date, _ end: Date) -> Int {
        let startDay = startOfDay(for: start)
        let endDay = startOfDay(for: end)
        return dateComponents([.day], from: startDay, to: endDay).day!
    }
    
    /// The number of years from `start` to `end`. Ignores units smaller than day.
    public func yearsBetween(_ start: Date, _ end: Date) -> Int {
        let startDay = startOfDay(for: start)
        let endDay = startOfDay(for: end)
        return dateComponents([.year], from: startDay, to: endDay).year!
    }
    
    /// The number of years and remainder months from `start` to `end`. Ignores units smaller than day.
    public func yearsAndMonthsBetween(_ start: Date, _ end: Date) -> (years: Int, months: Int) {
        let startDay = startOfDay(for: start)
        let endDay = startOfDay(for: end)
        let components = dateComponents([.year, .month], from: startDay, to: endDay)
        return (years: components.year!, months: components.month!)
    }
    
    /// Subtract 1 second from today to make the search behave as a >= today search.
    public func nextDateAtOr(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy = .strict) -> Date? {
        return self.nextDate(after: date-1, matching: components, matchingPolicy: matchingPolicy)
    }
}
