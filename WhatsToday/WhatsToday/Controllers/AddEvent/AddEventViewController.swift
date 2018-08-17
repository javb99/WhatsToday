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
    
    /// The cell to use for the preview.
    var previewCell: EventTableViewCell!
    
    /// The CellConfigurer responsible for configuring the previewCell.
    let cellConfigurer = EventCellConfigurer()
    
    /// The table view to hold the preview cell.
    var previewTableView: IntrinsicTableView!
    
    /// Needed to keep a strong reference to the data source.
    var previewDataSource: ArrayDataSource!
    
    /// Will be swapped back and forth with the keyboardConstraint.
    var safeAreaConstraint: NSLayoutConstraint?
    
    var currentEvent: Event = EventPopulator().createRandomEvents(count: 1).first! {
        didSet {
            refreshPreviewCell()
        }
    }
    
    /// The delegate is informed of completion and cancelation.
    weak var delegate: AddEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavBarItem()
        configurePreviewCell()
        configurePreviewTableView()
        addEventInputController()
        setUpConstraints()
        
        refreshPreviewCell()
    }
    
    func configureNavBarItem() {
        navigationItem.title = "Create Event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(completePressed(_:)))
    }
    
    func configurePreviewCell() {
        let nib = EventTableViewCell.standardEventNib
        guard let previewCell = nib.instantiate(withOwner: nil, options: nil).first as? EventTableViewCell else {
            fatalError("Failed to load the nib. You must have changed something critical.")
        }
        
        self.previewCell = previewCell
    }
    
    /// Must be called after configurePreviewCell().
    func configurePreviewTableView() {
        guard let previewCell = previewCell else { fatalError("previewCell is nil. configurePreviewTableView is probably called before configurePreviewCell. This should not be the case.") }
        
        let tableView = IntrinsicTableView(frame: .zero, style: .plain)
        
        previewDataSource = ArrayDataSource(sections: [[previewCell]], headerTitles: ["Preview"])
        tableView.dataSource = previewDataSource
        
        tableView.isUserInteractionEnabled = false
        
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.lightGray
        
        previewTableView = tableView
        view.addSubview(previewTableView)
    }
    
    func addEventInputController() {
        let eventInputController = EventInputTableViewController(style: .grouped)
        
        // 4 boilerplate lines to add the controller.
        addChildViewController(eventInputController)
        eventInputController.view.frame = .zero
        view.addSubview(eventInputController.view)
        eventInputController.didMove(toParentViewController: self)
        
        eventInputController.delegate = self
        
        self.eventInputController = eventInputController
    }
    
    func setUpConstraints() {
        previewTableView.translatesAutoresizingMaskIntoConstraints = false
        eventInputController.view.translatesAutoresizingMaskIntoConstraints = false
        
        eventInputController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        eventInputController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        eventInputController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        eventInputController.view.bottomAnchor.constraint(equalTo: previewTableView.topAnchor, constant: 0).isActive = true
        
        previewTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        previewTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        safeAreaConstraint = previewTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        safeAreaConstraint?.isActive = true
    }
    
    func refreshPreviewCell() {
        guard let previewCell = previewCell else { return }
        cellConfigurer.configureCell(previewCell, using: currentEvent.nextReminder(using: cellConfigurer.calender))
    }
    
    // MARK: Completion/Cancelation
    
    /// Completion button has been pressed. Form the Event and inform the delegate of completion.
    @IBAction func completePressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCompleted(self, with: currentEvent)
    }
    
    /// Cancel button has been pressed. Inform the delegate of cancelation.
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.addEventViewControllerCanceled(self)
    }
}

extension AddEventViewController: EventInputDelegate {
    
    func titleChanged(_ newTitle: String) {
        // Duplicate currentEvent changing the title.
        currentEvent = Event(title: newTitle, iconName: currentEvent.iconName, date: currentEvent.date, lengthType: currentEvent.lengthType, reminderFrequency: currentEvent.reminderFrequency)
    }
    
    func dateChanged(_ newDate: Date) {
        // Duplicate currentEvent changing the date.
        currentEvent = Event(title: currentEvent.title, iconName: currentEvent.iconName, date: newDate, lengthType: currentEvent.lengthType, reminderFrequency: currentEvent.reminderFrequency)
    }
}
