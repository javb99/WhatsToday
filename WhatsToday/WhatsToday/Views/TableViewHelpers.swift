//
//  TableViewHelpers.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/16/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

/// This is a protocol to be implemented by an enum inside any UITableViewCell subclass that uses the reuse identifier.
protocol TableViewCellIdentifier {
    var rawValue: String { get }
    var nib: UINib { get }
}

extension UITableView {
    // Registers a nib object containing a cell with the table view under a specified identifier. See register(_:forCellReuseIdentifier:)
    func registerCellIdentifierAndNib(_ cellIdentifier: TableViewCellIdentifier) {
        register(cellIdentifier.nib, forCellReuseIdentifier: cellIdentifier.rawValue)
    }
}
