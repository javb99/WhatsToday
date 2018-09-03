//
//  CalendarCalculations.swift
//  WhatsTodayTests
//
//  Created by Joseph Van Boxtel on 9/3/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import XCTest
@testable import WhatsToday

class CalendarCalculations: XCTestCase {
    
    let calendar = Calendar.current
    
    func testToday() {
        // This test will work as long as the day doesn't change between the call for now and today.
        let now = Date()
        let todaysDate = calendar.dateComponents([.day, .month, .year], from: now)
        let today = calendar.today
        XCTAssertEqual(todaysDate.year, calendar.component(.year, from: today))
        XCTAssertEqual(todaysDate.month, calendar.component(.month, from: today))
        XCTAssertEqual(todaysDate.day, calendar.component(.day, from: today))
    }
    
    func testDaysAway() {
        let now = Date()
        
        let yesterday = calendar.date(byAdding: DateComponents(day: -1), to: now)!
        XCTAssertEqual(calendar.daysAway(from: yesterday), -1)
        
        let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: now)!
        XCTAssertEqual(calendar.daysAway(from: tomorrow), 1)
        
        let oneWeekAway = calendar.date(byAdding: DateComponents(day: 7), to: now)!
        XCTAssertEqual(calendar.daysAway(from: oneWeekAway), 7)
    }

    func testDaysBetween() {
        let sep2ndMidnight2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2))!
        let oct2ndMidnight2018 = calendar.date(from: DateComponents(year: 2018, month: 10, day: 2))!
        let sep2ndNoon2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2, hour: 12))!
        
        XCTAssertEqual(0, calendar.daysBetween(sep2ndNoon2018, sep2ndNoon2018))
        XCTAssertEqual(30, calendar.daysBetween(sep2ndMidnight2018, oct2ndMidnight2018))
    }
    
    func testYearsBetween() {
        let sep2ndMidnight1999 = calendar.date(from: DateComponents(year: 1999, month: 9, day: 2))!
        let sep2ndNoon1999 = calendar.date(from: DateComponents(year: 1999, month: 9, day: 2, hour: 12))!
        
        let sep2ndMidnight2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2))!
        let sep2ndNoon2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2, hour: 12))!
        
        let sep2ndNoon2017 = calendar.date(from: DateComponents(year: 2017, month: 9, day: 2, hour: 12))!
        
        XCTAssertEqual(19, calendar.yearsBetween(sep2ndNoon1999, sep2ndNoon2018))
        XCTAssertEqual(19, calendar.yearsBetween(sep2ndMidnight1999, sep2ndMidnight2018))
        XCTAssertEqual(19, calendar.yearsBetween(sep2ndNoon1999, sep2ndMidnight2018))
        XCTAssertEqual(19, calendar.yearsBetween(sep2ndMidnight1999, sep2ndNoon2018))
        XCTAssertEqual(18, calendar.yearsBetween(sep2ndMidnight1999, sep2ndNoon2017))
    }
    
    func testYearsAndMonthsBetween() {
        let sep2ndNoon1999 = calendar.date(from: DateComponents(year: 1999, month: 9, day: 2, hour: 12))!
        let sep2ndMidnight2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2))!
        let sep2ndNoon2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2, hour: 12))!
        let june2ndNoon2017 = calendar.date(from: DateComponents(year: 2017, month: 6, day: 2, hour: 12))!
        
        XCTAssertEqual(19, calendar.yearsAndMonthsBetween(sep2ndNoon1999, sep2ndNoon2018).years)
        XCTAssertEqual(0, calendar.yearsAndMonthsBetween(sep2ndNoon1999, sep2ndNoon2018).months)
        
        XCTAssertEqual(1, calendar.yearsAndMonthsBetween(june2ndNoon2017, sep2ndMidnight2018).years)
        XCTAssertEqual(3, calendar.yearsAndMonthsBetween(june2ndNoon2017, sep2ndMidnight2018).months)
    }

    func testNextDateAtOrAfter() {
        let sep2nd2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2))!
        let sep3nd2017 = calendar.date(from: DateComponents(year: 2017, month: 9, day: 3))!
        
        let nextSep2nd = calendar.nextDateAtOr(after: sep3nd2017, matching: DateComponents(month: 9, day: 2))!
        XCTAssertEqual(nextSep2nd, sep2nd2018)
        
        let nextSep3rd = calendar.nextDateAtOr(after: sep3nd2017, matching: DateComponents(month: 9, day: 3))!
        XCTAssertEqual(nextSep3rd, sep3nd2017)
    }
}
