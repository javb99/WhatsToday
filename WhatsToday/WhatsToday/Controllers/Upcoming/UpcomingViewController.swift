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
        
        /// The cells that have are for events that happen today or tomorrow.
        static let closeEventCellIdentifier = "CloseEvent"
        /// The nib for cells that have are for events that happen today or tomorrow.
        static let closeEventTableViewCellNib = UINib(nibName: "CloseEventTableViewCell", bundle: nil)
    }
    
    let calendarCalculator = CalendarCalculator()
    
    // The original events. This would be the birthdate.
    var events: [Event] = []
    
    // The upcoming anniversary of the event.
    var upcomingEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["William", "Joe", "Khrystyna", "Sam", "Abbie"]
        
        // Create 20 random events.
        for _ in 0..<20 {
            let titleIndex = Int(arc4random()) % titles.count
            // Integer between 2 and 21. (Inclusive)
            let yearsBack = (arc4random() % 20) + 2
            // Multiply years by the number of seconds in a year. (Rough)
            let secondsBack = 0 - Double(60 * 60 * 24 * 365 * yearsBack)
            let event = Event(title: titles[titleIndex], iconName: "giftBox", date: Date(timeIntervalSinceNow: secondsBack), lengthType: .age)
            // Add the event to the events array.
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
        
        // Set up dynamic sized rows.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        // Tells the table view to use the nib(compiled xib file) when we ask for a cell with that identifier.
        tableView.register(StoryboardConstants.eventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.standardEventCellIdentifier)
        tableView.register(StoryboardConstants.closeEventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.closeEventCellIdentifier)
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = events[indexPath.row]
        let upcomingEvent = upcomingEvents[indexPath.row]
        
        let daysAway = calendarCalculator.daysBetween(Date(), upcomingEvent.date)
        
        // If the upcoming event is tomorrow or today, use a different cell.
        var identifier: String
        if daysAway <= 1 {
            identifier = StoryboardConstants.closeEventCellIdentifier
        } else {
            identifier = StoryboardConstants.standardEventCellIdentifier
        }
        
        // Ask the tableView for a cell that matches the identifier. And treats it as an EventTableViewCell because we know it always will be.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableViewCell else { fatalError() }
        
        // Sets the image on the left of the cell. For example, the gift box.
        cell.typeIconView.image = UIImage(named: upcomingEvent.iconName)
        
        // Sets the title. For birthdays it will probably be a name.
        cell.titleLabel.text = upcomingEvent.title
        
        let yearsOld = calendarCalculator.yearsBetween(event.date, upcomingEvent.date)
        cell.lengthLabel.text = "\(yearsOld) years old"
        cell.lengthLabel.textColor = UIColor.darkGray
        
        if identifier == StoryboardConstants.standardEventCellIdentifier {
            cell.daysLabel.text = "\(daysAway) Days"
            
            let month = calendarCalculator.calendar.component(.month, from: upcomingEvent.date)
            // Get the month name from the month number. Subtract one because the monthSymbols are 0-based.
            let monthLabel = calendarCalculator.calendar.shortMonthSymbols[month-1]
            let day = calendarCalculator.calendar.component(.day, from: upcomingEvent.date)
            // Set the date label to a formatted date. In the future we may use a DateFormatter for this.
            cell.dateLabel.text = "\(monthLabel) \(day)"
            
        } else if identifier == StoryboardConstants.closeEventCellIdentifier {
            if daysAway == 0 {
                cell.daysLabel.text = "Today"
            } else {
                cell.daysLabel.text = "Tomorrow"
            }
        }
        
        return cell
    }

}
