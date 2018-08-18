//
//  UIViewExtensions.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Animates the constraint changes by calling layoutIfNeeded in an animation block.
    func animateConstraintChanges(withDuration duration: TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], changes: @escaping ()->Void, completion: ((Bool)->Void)? = nil) {
        
        layoutIfNeeded()
        changes()
        let animationBlock = {
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animationBlock , completion: completion)
    }
    
    /// Animates the constraint changes by calling layoutIfNeeded in an animation block.
    func animateConstraintChanges(withDuration duration: TimeInterval, changes: @escaping ()->Void) {
        animateConstraintChanges(withDuration: duration, delay: 0, options: [], changes: changes, completion: nil)
    }
}
