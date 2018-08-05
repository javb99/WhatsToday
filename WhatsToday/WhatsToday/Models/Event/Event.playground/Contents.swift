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

// Birthday events can be created like this.
// I'm not sure that only storing the iconName is good enough. That will make it difficult if we want to be able to show custom images.
// NOTE: A TimeInterval is just a Double that holds a quantity of seconds.
let eighteenYearsAgo = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 365 * 18))
let williamsBirthday = Event(title: "William", iconName:  "giftBox_80px", date: eighteenYearsAgo, lengthType: .age)
