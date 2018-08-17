//
//  UpcomingViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class UpcomingViewController: UITableViewController, AddEventDelegate {
    
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
    
    let eventCellConfigurer = EventCellConfigurer()
    
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
        // Find the next anniversary for all the events in EventStorage.
        upcomingEvents = EventStorage.shared.events.map { calendarCalculator.nextNotableAnniversary(of: $0, granularity: .yearly) }
        
        // Sort based on the number of days away from today. Fewest to most.
        upcomingEvents.sort(by: should(_:comeBefore:))
    }
    
    /// Returns true if anniversaryA is closer to today and thus should be ordered before anniversaryB.
    func should(_ anniversaryA: Anniversary, comeBefore anniversaryB: Anniversary) -> Bool {
        let today = calendarCalculator.calendar.today
        let daysToA = calendarCalculator.calendar.daysBetween(today, anniversaryA.date)
        let daysToB = calendarCalculator.calendar.daysBetween(today, anniversaryB.date)
        return daysToA < daysToB
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    
    func cellIdentifier(for indexPath: IndexPath, upcomingEvent: Anniversary) -> String {
        let daysAway = calendarCalculator.calendar.daysAway(from: upcomingEvent.date)
        
        // If the upcoming event is tomorrow or today, use a different cell.
        var identifier: String
        if daysAway <= 1 {
            identifier = StoryboardConstants.closeEventCellIdentifier
        } else {
            identifier = StoryboardConstants.standardEventCellIdentifier
        }
        return identifier
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingEvent = upcomingEvents[indexPath.row]
        
        let identifier = cellIdentifier(for: indexPath, upcomingEvent: upcomingEvent)
        
        // Ask the tableView for a cell that matches the identifier. And treats it as an EventTableViewCell because we know it always will be.
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! EventTableViewCell
        
        eventCellConfigurer.configureCell(cell, using: upcomingEvent)
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // The anniversary at this row.
            let anniversary = upcomingEvents[indexPath.row]
            // Remove the event originally added by the user.
            EventStorage.shared.remove(anniversary.originalEvent)
            // Then update the upcomingEvents and delete that row in the table.
            refreshUpcomingEvents()
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
        EventStorage.shared.add(event)
        
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
