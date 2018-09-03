//: [Previous](@previous)

import Foundation
import WhatsTodayPlaygroundAccessible

let calendar = Calendar.current
let sep2ndMidnight1999 = calendar.date(from: DateComponents(year: 1999, month: 9, day: 2))!
let sep2ndNoon1999 = calendar.date(from: DateComponents(year: 1999, month: 9, day: 2, hour: 12))!

let sep2ndMidnight2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2))!
let sep2ndNoon2018 = calendar.date(from: DateComponents(year: 2018, month: 9, day: 2, hour: 12))!

// Trims to midnight that day.
calendar.startOfDay(for: Date())

calendar.daysBetween(sep2ndNoon1999, sep2ndNoon2018)

assert(19 == calendar.yearsBetween(sep2ndNoon1999, sep2ndNoon2018))
assert(19 == calendar.yearsBetween(sep2ndMidnight1999, sep2ndMidnight2018))
assert(19 == calendar.yearsBetween(sep2ndNoon1999, sep2ndMidnight2018))
assert(19 == calendar.yearsBetween(sep2ndMidnight1999, sep2ndNoon2018))

//: [Next](@next)
