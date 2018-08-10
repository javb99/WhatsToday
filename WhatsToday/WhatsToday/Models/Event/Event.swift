//
//  Event.swift
//  WhatsToday
//
//  Created by William Rush on 8/5/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import Foundation

enum LengthType: Int, Codable {
    /// Years old
    case age
    /// Years
    case period
}

struct Event: Codable {
    let title: String
    var iconName: String
    let date: Date
    var lengthType: LengthType
}

extension Event: Equatable {
    
    /// Two Event values are considered equal if their title and date are equal.
    static func ==(_ lhs: Event, _ rhs: Event) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date
    }
}
