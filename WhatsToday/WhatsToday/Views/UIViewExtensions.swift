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

extension UIView {
    
    /// Sets the `translatesAutoresizingMaskIntoConstraints` property to `false` on all the views.
    static func disableAutoresizingMaskConstraints(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// Adds constraints between the receiver and it's superview to fill it leaving a margin defined by `insets`. The constraints are activated.
    ///
    /// - Parameter insets: The leading constraint uses the `left` value of the insets and the trailing constraint uses the `right` value of the insets.
    /// - Returns: The constraints that were activated.
    @discardableResult
    func constrainFillSuperview(_ insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            preconditionFailure("superview must not be nil.")
        }
        
        let top = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        let bottom = self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        let leading = self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        let trailing = self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        
        let constraints = [top, bottom, leading, trailing]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
