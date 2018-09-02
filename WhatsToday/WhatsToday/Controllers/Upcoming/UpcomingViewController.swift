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
        configureNavigationItem()
    }
    
    /// Register cell identifiers and do other initial configuration for the tableView. This is currently intended to be called during viewDidLoad.
    func configureTableView() {
        tableView.allowsSelection = false
        
        // Set up dynamic sized rows.
        tableView.rowHeight = UITableViewAutomaticDimension
        // Currently this is the height in the xib. TODO: Adjust this based on dynamic text size.
        tableView.estimatedRowHeight = 60
        
        // Tells the table view to use the class initializer when we ask for a cell with that identifier.
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.standardEventIdentifier)
    }
    
    func configureNavigationItem() {
        navigationItem.title = "Upcoming"
        navigationItem.largeTitleDisplayMode = .always
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(showAddEventViewController(_:)))
        navigationItem.rightBarButtonItem = addButton
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingEvent = upcomingReminders[indexPath.row]
        
        let identifier = EventTableViewCell.standardEventIdentifier
        
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
    
    func createAddEventViewController() -> UIViewController {
        let addEventVC = AddEventViewController()
        let navVC = UINavigationController(rootViewController: addEventVC)
        addEventVC.delegate = self
        return navVC
    }
    
    @IBAction func showAddEventViewController(_ sender: Any) {
        present(createAddEventViewController(), animated: true, completion: nil)
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
