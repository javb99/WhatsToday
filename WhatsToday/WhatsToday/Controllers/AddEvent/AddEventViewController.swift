//
//  AddEventViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/7/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public protocol AddEventDelegate: class {
    /// The process of creating an Event has completed. It is expected that the adopter stores this Event and dismisses this ViewController.
    func addEventViewControllerCompleted(_ controller: AddEventViewController, with event: Event)
    /// The process of creating an Event has been canceled. It is expected that the adopter dismisses this ViewController.
    func addEventViewControllerCanceled(_ controller: AddEventViewController)
}

/// A ViewController that is responsible for creating new Events.
public class AddEventViewController: UIViewController {
    
    /// The table view that holds all the editing fields.
    public var eventInputController: EventInputTableViewController!
    
    /// The table view to hold the preview cell.
    public var eventPreviewController: EventCellPreviewViewController!
    
    /// A constraint to make space for the keyboard.
    private var keyboardSpacerConstraint: NSLayoutConstraint?
    
    /// Will be swapped back and forth with the keyboardConstraint.
    private var safeAreaConstraint: NSLayoutConstraint?
    
    /// The delegate is informed of completion and cancelation.
    public weak var delegate: AddEventDelegate?
    
    
    /// This will remove the observer when the VC deallocates.
    private var keyboardWillChangeFrameToken: NotificationToken?
    
    /// This will remove the observer when the VC deallocates.
    private var keyboardWillHideToken: NotificationToken?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavBarItem()
        addCellPreviewController()
        addEventInputController()
        setUpConstraints()
        setupKeyboardObserving()
    }
    
    private func configureNavBarItem() {
        navigationItem.title = "Create Event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(completePressed(_:)))
    }
    
    /// Create an EventCellPreviewViewController and add it as a child view controller.
    private func addCellPreviewController() {
        let cellPreviewController = EventCellPreviewViewController(style: .plain)
        addChildViewControllerBasicConnection(cellPreviewController)
        eventPreviewController = cellPreviewController
    }
    
    /// Create an EventInputTableViewController and add it as a child view controller.
    private func addEventInputController() {
        let eventInputController = EventInputTableViewController(style: .grouped)
        addChildViewControllerBasicConnection(eventInputController)
        eventInputController.delegate = self
        self.eventInputController = eventInputController
    }
    
    private func setUpConstraints() {
        eventPreviewController.view.translatesAutoresizingMaskIntoConstraints = false
        eventInputController.view.translatesAutoresizingMaskIntoConstraints = false
        
        eventInputController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        eventInputController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        eventInputController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        eventInputController.view.bottomAnchor.constraint(equalTo: eventPreviewController.view.topAnchor, constant: 0).isActive = true
        
        eventPreviewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        eventPreviewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        keyboardSpacerConstraint = eventPreviewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        keyboardSpacerConstraint?.identifier = "Keyboard Spacer"
        safeAreaConstraint = eventPreviewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        safeAreaConstraint?.identifier = "Safe Area Constraint"
        safeAreaConstraint?.isActive = true
    }
    
    private func setupKeyboardObserving() {
        let center = NotificationCenter.default
        keyboardWillChangeFrameToken = center.addObserver(descriptor: KeyboardPayload.willChangeFrame, using: adjustForKeyboard)
        keyboardWillHideToken = center.addObserver(descriptor: KeyboardPayload.willHide, using: keyboardWillHide)
    }
    
    // MARK: Completion/Cancelation
    
    /// Completion button has been pressed. Form the Event and inform the delegate of completion.
    @IBAction public func completePressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCompleted(self, with: eventPreviewController.currentEvent)
    }
    
    /// Cancel button has been pressed. Inform the delegate of cancelation.
    @IBAction public func cancelPressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCanceled(self)
    }
}

extension AddEventViewController: EventInputDelegate {
    
    public func titleChanged(_ newTitle: String) {
        // Duplicate currentEvent changing the title.
        let e = eventPreviewController.currentEvent
        eventPreviewController.currentEvent = Event(title: newTitle, iconName: e.iconName, date: e.date, lengthType: e.lengthType, reminderFrequency: e.reminderFrequency)
    }
    
    public func dateChanged(_ newDate: Date) {
        // Duplicate currentEvent changing the date.
        let e = eventPreviewController.currentEvent
        eventPreviewController.currentEvent = Event(title: e.title, iconName: e.iconName, date: newDate, lengthType: e.lengthType, reminderFrequency: e.reminderFrequency)
    }
}

extension AddEventViewController {
    
    public func adjustForKeyboard(_ payload: KeyboardPayload) {
        let newFrame = view.convert(payload.frameEnd, from: view.window)
        
        // Apply pending updates before we add ours.
        view.animateConstraintChanges(withDuration: payload.duration) {
            self.safeAreaConstraint?.isActive = false
            // Negative height because iOS coordinates start in the top left.
            self.keyboardSpacerConstraint?.constant = -newFrame.height
            self.keyboardSpacerConstraint?.isActive = true
        }
    }
    
    public func keyboardWillHide(_ payload: KeyboardPayload) {
        // TODO: Adjust the curve to match the payload.
        view.animateConstraintChanges(withDuration: payload.duration) {
            self.keyboardSpacerConstraint?.isActive = false
            self.safeAreaConstraint?.isActive = true
        }
    }
}
