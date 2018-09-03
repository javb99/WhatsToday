//
//  ArrayTableViewDataSource.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public class ArrayDataSource: NSObject, UITableViewDataSource {
    
    public var sections: [[UITableViewCell]]
    
    public var headerTitles: [String?]?
    public var footerTitles: [String?]?
    
    public init(sections: [[UITableViewCell]], headerTitles: [String?]? = nil, footerTitles: [String?]? = nil) {
        self.sections = sections
        self.headerTitles = headerTitles
        self.footerTitles = footerTitles
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section][indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles?[section]
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitles?[section]
    }
}
