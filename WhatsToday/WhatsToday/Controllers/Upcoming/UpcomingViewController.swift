//
//  UpcomingViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class UpcomingViewController: UITableViewController, AddEventDelegate {
    
    enum OutboundSegueIdentifier: String, VCOutgoingSequeIdentifier {
        case showAddEvent = "ShowAddEvent"
    }
    
    let calendar = Calendar.autoupdatingCurrent
    
    let eventCellConfigurer = EventCellConfigurer()
    
    // The upcoming reminder of the event.
    var upcomingReminders: [Reminder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create reminder events.
        refreshUpcomingEvents()
        
        configureTableView()
    }
    
    /// Register cell identifiers and do other initial configuration for the tableView. This is currently intended to be called during viewDidLoad.
    func configureTableView() {
        tableView.allowsSelection = false
        
        // Set up dynamic sized rows.
        tableView.rowHeight = UITableViewAutomaticDimension
        // Currently this is the height in the xib. TODO: Adjust this based on dynamic text size.
        tableView.estimatedRowHeight = 60
        
        // Tells the table view to use the nib(compiled xib file) when we ask for a cell with that identifier.
        tableView.register(EventTableViewCell.standardEventNib, forCellReuseIdentifier: EventTableViewCell.standardEventIdentifier)
        tableView.register(EventTableViewCell.closeEventNib, forCellReuseIdentifier: EventTableViewCell.closeEventIdentifier)
    }
    
    func refreshUpcomingEvents() {
        // Find the next reminder for all the events in EventStorage.
        upcomingReminders = EventStorage.shared.events.map { $0.nextReminder(using: self.calendar) }
        
        // Sort based on the number of days away from today. Fewest to most.
        upcomingReminders.sort { $0.date < $1.date }
    }
    
    // MARK: Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingReminders.count
    }
    
    func cellIdentifier(for indexPath: IndexPath, upcomingEvent: Reminder) -> String {
        let daysAway = calendar.daysAway(from: upcomingEvent.date)
        
        // If the upcoming event is tomorrow or today, use a different cell.
        var identifier: String
        if daysAway <= 1 {
            identifier = EventTableViewCell.closeEventIdentifier
        } else {
            identifier = EventTableViewCell.standardEventIdentifier
        }
        return identifier
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingEvent = upcomingReminders[indexPath.row]
        
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
            // The reminder at this row.
            let reminder = upcomingReminders[indexPath.row]
            // Remove the event originally added by the user.
            EventStorage.shared.remove(reminder.originalEvent)
            // Then update the upcomingReminders and delete that row in the table.
            refreshUpcomingEvents()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, let identifier = OutboundSegueIdentifier(rawValue: id) else {
            fatalError("Unknown segue identifier: \(segue.identifier ?? "nil")")
        }
        
        switch identifier {
        case .showAddEvent:
            let navController = segue.destination as! UINavigationController
            let controller = navController.childViewControllers.first as! AddEventViewController
            controller.delegate = self
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
