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
    
    let calendarCalculator = CalendarCalculator()
    
    // The original events. This would be the birthdate.
    var events: [Event] = []
    
    // The upcoming anniversary of the event.
    var upcomingEvents: [Event] = []

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
        
        // Create anniversary events.
        for event in events {
            // Copy the event.
            var anniversary = event
            // Find the date of the anniversary.
            let anniversaryDate = calendarCalculator.nextNotableAnniversary(of: event.date, granularity: .yearly)
            // Set the date on anniversary
            anniversary.date = anniversaryDate!
            // Add anniversary to the array that is displayed by the table view.
            upcomingEvents.append(anniversary)
        }
        
        tableView.register(StoryboardConstants.eventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.standardEventCellIdentifier)
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.standardEventCellIdentifier) as? EventTableViewCell else { fatalError() }
        
        let event = events[indexPath.row]
        let upcomingEvent = upcomingEvents[indexPath.row]
        
        cell.typeIconView.image = UIImage(named: upcomingEvent.iconName)
        cell.titleLabel.text = upcomingEvent.title
        
        let yearsOld = calendarCalculator.yearsBetween(event.date, upcomingEvent.date)
        cell.lengthLabel.text = "\(yearsOld) years old"
        cell.lengthLabel.textColor = UIColor.darkGray
        
        let daysAway = calendarCalculator.daysBetween(Date(), upcomingEvent.date)
        cell.daysLabel.text = "\(daysAway) Days"
        
        let month = calendarCalculator.calendar.component(.month, from: upcomingEvent.date)
        let monthLabel = calendarCalculator.calendar.shortMonthSymbols[month-1]
        let day = calendarCalculator.calendar.component(.day, from: upcomingEvent.date)
        cell.dateLabel.text = "\(monthLabel) \(day)"
        
        return cell
    }

}
