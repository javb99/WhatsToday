//
//  UpcomingViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

public class UpcomingViewController: UITableViewController, AddEventDelegate, CNContactPickerDelegate {
    
    public enum OutboundSegueIdentifier: String, VCOutgoingSequeIdentifier {
        case showAddEvent = "ShowAddEvent"
    }
    
    public let calendar = Calendar.autoupdatingCurrent
    
    public let eventCellConfigurer = EventCellConfigurer()
    
    // The upcoming reminder of the event.
    public private(set) var upcomingReminders: [Reminder] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create reminder events.
        refreshUpcomingEvents()
        
        configureTableView()
        configureNavigationItem()
        configureToobarItems()
    }
    
    /// Register cell identifiers and do other initial configuration for the tableView. This is currently intended to be called during viewDidLoad.
    private func configureTableView() {
        tableView.allowsSelection = false
        
        // Set up dynamic sized rows.
        tableView.rowHeight = UITableViewAutomaticDimension
        // Currently this is the height in the xib. TODO: Adjust this based on dynamic text size.
        tableView.estimatedRowHeight = 60
        
        // Tells the table view to use the class initializer when we ask for a cell with that identifier.
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.standardEventIdentifier)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Upcoming"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureToobarItems() {
        let importContactsButton = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(showImportScreen))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddEventViewController(_:)))
        
        toolbarItems = [importContactsButton, flexibleSpace, createButton]
    }
    
    public func refreshUpcomingEvents() {
        // Find the next reminder for all the events in EventStorage.
        upcomingReminders = EventStorage.shared.events.map { $0.nextReminder(using: self.calendar) }
        
        // Sort based on the number of days away from today. Fewest to most.
        upcomingReminders.sort { $0.date < $1.date }
    }
    
    // MARK: Data Source
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingReminders.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingEvent = upcomingReminders[indexPath.row]
        
        let identifier = EventTableViewCell.standardEventIdentifier
        
        // Ask the tableView for a cell that matches the identifier. And treats it as an EventTableViewCell because we know it always will be.
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! EventTableViewCell
        
        eventCellConfigurer.configureCell(cell, using: upcomingEvent)
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    public func addEventViewControllerCompleted(_ controller: AddEventViewController, with event: Event) {
        // Add the Event to storage.
        EventStorage.shared.add(event)
        
        // Create the annivarsary value and reload the table.
        refreshUpcomingEvents()
        tableView.reloadData()
        
        // Dismiss the AddEventViewController
        dismiss(animated: true, completion: nil)
    }
    
    public func addEventViewControllerCanceled(_ controller: AddEventViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Contacts import.
    
    @IBAction public func showImportScreen() {
        let contactPickerController = CNContactPickerViewController()
        contactPickerController.predicateForEnablingContact = CNContact.predicateForHavingABirthday
        contactPickerController.predicateForSelectionOfContact = CNContact.predicateForHavingABirthday
        contactPickerController.delegate = self
        present(contactPickerController, animated: true, completion: nil)
    }
    
    public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // Create and store birthday events for each of the selected contacts.
        EventStorage.shared.add(contentsOf: contacts.compactMap(Event.init))
        
        refreshUpcomingEvents()
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

extension CNContact {
    public static let predicateForHavingABirthday: NSPredicate = NSPredicate(format: "birthday != nil")
}
