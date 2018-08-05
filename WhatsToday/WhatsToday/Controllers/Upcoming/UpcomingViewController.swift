//
//  UpcomingViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class UpcomingViewController: UITableViewController {
    
    struct StoryboardConstants {
        static let standardEventCellIdentifier = "StandardEvent"
        static let eventTableViewCellNib = UINib(nibName: "EventTableViewCell", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(StoryboardConstants.eventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.standardEventCellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandardEvent") as? EventTableViewCell else { fatalError() }
        
        cell.typeIconView.image = UIImage(named: "giftBox")
        cell.titleLabel.text = "John Doe"
        cell.lengthLabel.text = "40 years old"
        cell.lengthLabel.textColor = UIColor.darkGray
        cell.daysLabel.text = "4 Days"
        cell.dateLabel.text = "Mar 3"
        
        return cell
    }

}
