//
//  Notification.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

/// A generic structure to create a more swift friendly api for Notifications.
public struct NotificationDescriptor<Payload> {
    public let name: Notification.Name
    public let convert: (Notification) -> Payload
}

/// A token that removes it self as an observer automatically.
/// Keep a reference to this object as long as you want to observe.
public class NotificationToken {
    public let token: NSObjectProtocol
    public let center: NotificationCenter
    
    public init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit {
        center.removeObserver(token)
    }
}

public extension NotificationCenter {
    /// A swifty wrapper around the addObserver(forName:object:queue:using:) closure based notification registration.
    public func addObserver<A>(descriptor: NotificationDescriptor<A>, using block: @escaping (A) -> ()) -> NotificationToken {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil, using: { note in
            block(descriptor.convert(note))
        })
        return NotificationToken(token: token, center: self)
    }
}

