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
    
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["William", "Joe", "Khrystyna", "Sam", "Abbie"]
        
        for _ in 0..<20 {
            let titleIndex = Int(arc4random()) % titles.count
            let yearsBack = (arc4random() % 20) + 2
            let secondsBack = 0 - Double(60 * 60 * 24 * 365 * yearsBack)
            let event = Event(title: titles[titleIndex], iconName: "giftBox", date: Date(timeIntervalSinceNow: secondsBack), lengthType: .age)
            events.append(event)
        }
        tableView.register(StoryboardConstants.eventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.standardEventCellIdentifier)
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.standardEventCellIdentifier) as? EventTableViewCell else { fatalError() }
        
        let event = events[indexPath.row]
        
        cell.typeIconView.image = UIImage(named: event.iconName)
        cell.titleLabel.text = event.title
        cell.lengthLabel.text = "40 years old"
        cell.lengthLabel.textColor = UIColor.darkGray
        cell.daysLabel.text = "4 Days"
        cell.dateLabel.text = "\(event.date)"
        
        return cell
    }

}
