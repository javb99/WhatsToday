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
    var title: String
    var iconName: String
    var date: Date
    var lengthType: LengthType
}
