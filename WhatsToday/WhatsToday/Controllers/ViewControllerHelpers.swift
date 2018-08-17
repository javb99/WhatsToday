//
//  ViewControllerHelpers.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/16/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

/// A protocol for enums inside any UIViewController subclass that has outgoing segues.
protocol VCOutgoingSequeIdentifier {
    var rawValue: String { get }
}
