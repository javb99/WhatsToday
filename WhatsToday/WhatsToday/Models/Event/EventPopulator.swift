//
//  EventPopulator.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/7/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

private func randomNumber(lessThan upperbound: Int) -> Int {
    return Int(arc4random()) % upperbound
}

/// A type to facilitate creation of test Event values.
struct EventPopulator {
    
    var titles = ["William", "Joe", "Khrystyna", "Sam", "Abbie"]
    func randomTitle() -> String {
        let index = randomNumber(lessThan: titles.count)
        return titles[index]
    }
    
    var iconNames = ["giftBox"]
    func randomIconName() -> String {
        let index = randomNumber(lessThan: iconNames.count)
        return iconNames[index]
    }
    
    func randomBirthdate() -> Date {
        let calendar = Calendar.autoupdatingCurrent
        // Pick a random year between 1950 and 2010.
        let year = randomNumber(lessThan: 60) + 1950
        var date = calendar.date(from: DateComponents(year: year))!
        
        // Pick a random month. We could just assume 12 months, but this is better code. It would be ready if we wanted to support other calendar types.
        let monthRange = calendar.range(of: .month, in: .year, for: date)!
        let month = randomNumber(lessThan: monthRange.upperBound - monthRange.lowerBound) + monthRange.lowerBound
        date = calendar.date(byAdding: DateComponents(month: month), to: date)!
        
        // Pick a random month. Taking into account the number of days in the month.
        let dayRange = calendar.range(of: .day, in: .month, for: date)!
        let day = randomNumber(lessThan: dayRange.upperBound - dayRange.lowerBound) + dayRange.lowerBound
        date = calendar.date(byAdding: DateComponents(day: day), to: date)!
        
        return date
    }
    
    /// Create `count` Event values
    func createRandomEvents(count: Int) -> [Event] {
        return (0..<count).map { _ in Event(title: randomTitle(), iconName: randomIconName(), date: randomBirthdate(), lengthType: .age, reminderFrequency: .yearly) }
    }
}
