//
//  AddEventViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/7/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

protocol AddEventDelegate: class {
    /// The process of creating an Event has completed. It is expected that the adopter stores this Event and dismisses this ViewController.
    func addEventViewControllerCompleted(_ controller: AddEventViewController, with event: Event)
    /// The process of creating an Event has been canceled. It is expected that the adopter dismisses this ViewController.
    func addEventViewControllerCanceled(_ controller: AddEventViewController)
}

/// A ViewController that is responsible for creating new Events.
class AddEventViewController: UIViewController {
    
    /// The table view that holds all the editing fields.
    var eventInputController: EventInputTableViewController!
    
    /// The table view to hold the preview cell.
    var eventPreviewController: EventCellPreviewViewController!
    
    /// Will be swapped back and forth with the keyboardConstraint.
    var safeAreaConstraint: NSLayoutConstraint?
    
    /// The delegate is informed of completion and cancelation.
    weak var delegate: AddEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavBarItem()
        addCellPreviewController()
        addEventInputController()
        setUpConstraints()
    }
    
    func configureNavBarItem() {
        navigationItem.title = "Create Event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(completePressed(_:)))
    }
    
    /// Create an EventCellPreviewViewController and add it as a child view controller.
    func addCellPreviewController() {
        let cellPreviewController = EventCellPreviewViewController(style: .plain)
        addChildViewControllerBasicConnection(cellPreviewController)
        eventPreviewController = cellPreviewController
    }
    
    /// Create an EventInputTableViewController and add it as a child view controller.
    func addEventInputController() {
        let eventInputController = EventInputTableViewController(style: .grouped)
        addChildViewControllerBasicConnection(eventInputController)
        eventInputController.delegate = self
        self.eventInputController = eventInputController
    }
    
    func setUpConstraints() {
        eventPreviewController.view.translatesAutoresizingMaskIntoConstraints = false
        eventInputController.view.translatesAutoresizingMaskIntoConstraints = false
        
        eventInputController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        eventInputController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        eventInputController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        eventInputController.view.bottomAnchor.constraint(equalTo: eventPreviewController.view.topAnchor, constant: 0).isActive = true
        
        eventPreviewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        eventPreviewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        safeAreaConstraint = eventPreviewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        safeAreaConstraint?.isActive = true
    }
    
    // MARK: Completion/Cancelation
    
    /// Completion button has been pressed. Form the Event and inform the delegate of completion.
    @IBAction func completePressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCompleted(self, with: eventPreviewController.currentEvent)
    }
    
    /// Cancel button has been pressed. Inform the delegate of cancelation.
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCanceled(self)
    }
}

extension AddEventViewController: EventInputDelegate {
    
    func titleChanged(_ newTitle: String) {
        // Duplicate currentEvent changing the title.
        let e = eventPreviewController.currentEvent
        eventPreviewController.currentEvent = Event(title: newTitle, iconName: e.iconName, date: e.date, lengthType: e.lengthType, reminderFrequency: e.reminderFrequency)
    }
    
    func dateChanged(_ newDate: Date) {
        // Duplicate currentEvent changing the date.
        let e = eventPreviewController.currentEvent
        eventPreviewController.currentEvent = Event(title: e.title, iconName: e.iconName, date: newDate, lengthType: e.lengthType, reminderFrequency: e.reminderFrequency)
    }
}
