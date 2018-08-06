//: A playground to describe Event
  
import UIKit

enum LengthType {
    /// Years old
    case age
    /// Years
    case period
}

struct Event {
    var title: String
    var iconName: String
    var date: Date
    var lengthType: LengthType
}

enum Importance {
    case yearly
}

extension Calendar {
    
    func nextNotableAnniversary(after start: Date, matching criteriaComponents: DateComponents, ofImportance importance: Importance) -> Date? {
        switch importance {
        case .yearly:
            return nextDate(after: start, matching: criteriaComponents, matchingPolicy: Calendar.MatchingPolicy.strict)
        }
    }
}

var calendar = Calendar(identifier: .gregorian)
calendar.locale = Locale.autoupdatingCurrent

let now = Date()

// Create a date from components month, day, and year
let williamsBdayComponents = DateComponents(year: 2000, month: 5, day: 4)
let williamsBDay = calendar.date(from: williamsBdayComponents)!

// Find the next anniversary.
let williamsNineteenthBday = calendar.nextNotableAnniversary(after: now, matching: DateComponents(month: 5, day: 4), ofImportance: Importance.yearly)!

// Find the year of the anniversary.
let years = calendar.dateComponents([.year], from: williamsBDay, to: williamsNineteenthBday).year!

// Find days away from now.
let daysTil19thBday = calendar.dateComponents([.day], from: now, to: williamsNineteenthBday).day!
let til19thBday = calendar.dateComponents([.day], from: now, to: williamsNineteenthBday)

let month = williamsBdayComponents.month!
let monthSymbol = calendar.shortMonthSymbols[month-1]

"\(daysTil19thBday) days until William turns \(years) years old on \(monthSymbol) \(williamsBdayComponents.day!)"




