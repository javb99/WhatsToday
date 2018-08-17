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

extension UIViewController {
    /// Add a UIViewController as a child. Performs necessary operations to add `vc`'s view to superview. Set's `vc`'s view's frame to zero because it assumes auto layout.
    func addChildViewControllerBasicConnection(_ vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = .zero
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}
