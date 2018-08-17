//
//  ArrayTableViewDataSource.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class ArrayDataSource: NSObject, UITableViewDataSource {
    
    var sections: [[UITableViewCell]]
    
    var headerTitles: [String?]?
    var footerTitles: [String?]?
    
    init(sections: [[UITableViewCell]], headerTitles: [String?]? = nil, footerTitles: [String?]? = nil) {
        self.sections = sections
        self.headerTitles = headerTitles
        self.footerTitles = footerTitles
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles?[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitles?[section]
    }
}
