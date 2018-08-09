//
//  UpcomingViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit



class UpcomingViewController: UITableViewController, AddEventDelegate {
    
    static let monthAndDayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Format: Mar 3
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        return dateFormatter
    }()
    
    struct StoryboardConstants {
        static let standardEventCellIdentifier = "StandardEvent"
        static let eventTableViewCellNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        
        /// The cells that have are for events that happen today or tomorrow.
        static let closeEventCellIdentifier = "CloseEvent"
        /// The nib for cells that have are for events that happen today or tomorrow.
        static let closeEventTableViewCellNib = UINib(nibName: "CloseEventTableViewCell", bundle: nil)
        
        static let showAddEventSegueIdentifier = "ShowAddEvent"
    }
    
    let calendarCalculator = CalendarCalculator()
    
    // The original events. This would be the birthdate.
    var events: [Event] = []
    
    // The upcoming anniversary of the event.
    var upcomingEvents: [Anniversary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create anniversary events.
        refreshUpcomingEvents()
        
        // Set up dynamic sized rows.
        tableView.rowHeight = UITableViewAutomaticDimension
        // Currently this is the height in the xib. TODO: Adjust this based on dynamic text size.
        tableView.estimatedRowHeight = 60
        
        // Tells the table view to use the nib(compiled xib file) when we ask for a cell with that identifier.
        tableView.register(StoryboardConstants.eventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.standardEventCellIdentifier)
        tableView.register(StoryboardConstants.closeEventTableViewCellNib, forCellReuseIdentifier: StoryboardConstants.closeEventCellIdentifier)
    }
    
    func refreshUpcomingEvents() {
        upcomingEvents = events.map { calendarCalculator.nextNotableAnniversary(of: $0, granularity: .yearly) }
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! EventTableViewCell
        
        // Sets the image on the left of the cell. For example, the gift box.
        cell.typeIconView.image = UIImage(named: upcomingEvent.originalEvent.iconName)
        
        // Sets the title. For birthdays it will probably be a name.
        cell.titleLabel.text = upcomingEvent.originalEvent.title
        
        
        let yearsOld = calendarCalculator.yearsBetween(upcomingEvent.originalEvent.date, upcomingEvent.date)
        cell.lengthLabel.text = "\(yearsOld) years old"
        cell.lengthLabel.textColor = UIColor.darkGray
        
        print("\(yearsOld) years between \(upcomingEvent.originalEvent.date) and \(upcomingEvent.date)")
        
        if identifier == StoryboardConstants.standardEventCellIdentifier {
            cell.daysLabel.text = "\(daysAway) Days"
            
            // Set the date label to a formatted date.
            cell.dateLabel.text = UpcomingViewController.monthAndDayFormatter.string(from: upcomingEvent.date)
            
        } else if identifier == StoryboardConstants.closeEventCellIdentifier {
            if daysAway == 0 {
                cell.daysLabel.text = "Today"
            } else {
                cell.daysLabel.text = "Tomorrow"
            }
        }
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            events.remove(at: indexPath.row)
            upcomingEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case StoryboardConstants.showAddEventSegueIdentifier:
            let controller = segue.destination as! AddEventViewController
            controller.delegate = self
        default:
            break
        }
    }
    
    // MARK: AddEventViewControllerDelegate implementation.
    
    func addEventViewControllerCompleted(_ controller: AddEventViewController, with event: Event) {
        // Add the Event to storage.
        events.append(event)
        
        // Create the annivarsary value and reload the table.
        refreshUpcomingEvents()
        tableView.reloadData()
        
        // Dismiss the AddEventViewController
        dismiss(animated: true, completion: nil)
    }
    
    func addEventViewControllerCanceled(_ controller: AddEventViewController) {
        dismiss(animated: true, completion: nil)
    }
}
