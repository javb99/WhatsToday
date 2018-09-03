//
//  EventCellConfigurer.swift
//  WhatsTodayTests
//
//  Created by Joseph Van Boxtel on 9/3/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import XCTest
@testable import WhatsToday

class EventCellConfigurerTests: XCTestCase {
    
    let cell = EventTableViewCell()
    let configurer = EventCellConfigurer()
    
    let sameDay: Reminder = {
        let date = Calendar.current.date(from: DateComponents(year: 2019, month: 9, day: 8))!
        let sameDay = Calendar.current.date(from: DateComponents(year: 2019, month: 9, day: 8))!
        return Reminder(originalEvent: Event(title: "Hello World!", iconName: "giftBox", date: date, lengthType: .age, reminderFrequency: .yearly), date: sameDay)
    }()
    
    let oneYearLater: Reminder = {
        let date = Calendar.current.date(from: DateComponents(year: 2018, month: 9, day: 8))!
        let oneYearLater = Calendar.current.date(from: DateComponents(year: 2019, month: 9, day: 8))!
        return Reminder(originalEvent: Event(title: "Hello World!", iconName: "giftBox", date: date, lengthType: .age, reminderFrequency: .yearly), date: oneYearLater)
    }()
    
    let twentyYearsLater: Reminder = {
        let date = Calendar.current.date(from: DateComponents(year: 2018, month: 9, day: 8))!
        let twentyYearsLater = Calendar.current.date(from: DateComponents(year: 2038, month: 9, day: 8))!
        return Reminder(originalEvent: Event(title: "Hello World!", iconName: "giftBox", date: date, lengthType: .age, reminderFrequency: .yearly), date: twentyYearsLater)
    }()

    func testLengthText() {
        configurer.configureCell(cell, using: oneYearLater)
        XCTAssertEqual(cell.lengthLabel.text!, "1st birthday")
        
        configurer.configureCell(cell, using: sameDay)
        XCTAssertEqual(cell.lengthLabel.text!, "0th birthday")
        
        configurer.configureCell(cell, using: twentyYearsLater)
        XCTAssertEqual(cell.lengthLabel.text!, "20th birthday")
    }

}
