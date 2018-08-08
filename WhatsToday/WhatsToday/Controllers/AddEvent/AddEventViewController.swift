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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    /// The delegate is informed of completion and cancelation.
    weak var delegate: AddEventDelegate?
    
    /// Pressing outside the keyboard should hide the keyboard.
    @IBAction func tappedBackgroundView(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }
    
    /// Send when the titleTextField presses the return key.
    @IBAction func finishedEditing(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    /// Completion button has been pressed. Form the Event and inform the delegate of completion.
    @IBAction func completePressed(_ sender: UIButton) {
        let fixedDate = Calendar.current.date(keeping: [.year, .month, .day], of: datePicker.date)
        let event = Event(title: titleTextField.text ?? "Untitled", iconName: "giftBox", date: fixedDate, lengthType: .age)
        delegate?.addEventViewControllerCompleted(self, with: event)
    }
    
    /// Cancel button has been pressed. Inform the delegate of cancelation.
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCanceled(self)
    }
}
