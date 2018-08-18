//
//  KeyboardNotifications.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

/// A wrapper for the Notification and it's userInfo for keyboard notifications. All the notification options are available as static constants.
struct KeyboardPayload {
    
    let name: Notification.Name
    let animationCurve: UIViewAnimationCurve
    let duration: Double
    let isLocal: Bool
    let frameBegin: CGRect
    let frameEnd: CGRect
    
    fileprivate init(notification: Notification) {
        name = notification.name
        animationCurve = UIViewAnimationCurve(rawValue: notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
        duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        isLocal = notification.userInfo?[UIKeyboardIsLocalUserInfoKey] as! Bool
        frameBegin = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        frameEnd = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
    }
}

/// Hold the constants for all notifications that use this payload.
extension KeyboardPayload {
    static let willChangeFrame = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardWillChangeFrame, convert: KeyboardPayload.init)
    static let didChangeFrame = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardDidChangeFrame, convert: KeyboardPayload.init)
    static let willShow = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardWillShow, convert: KeyboardPayload.init)
    static let didShow = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardDidShow, convert: KeyboardPayload.init)
    static let willHide = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardWillHide, convert: KeyboardPayload.init)
    static let didHide = NotificationDescriptor<KeyboardPayload>(name: .UIKeyboardDidHide, convert: KeyboardPayload.init)
}
