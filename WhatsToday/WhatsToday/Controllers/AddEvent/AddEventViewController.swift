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
class AddEventViewController: UIViewController, UITableViewDataSource {
    
    /// The table view that holds all the editing fields.
    var inputTableView: UITableView!
    
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
    
    /// The date picker in the cell for the date.
    var datePicker: UIDatePicker?
    
    /// The text field in the cell for the title. Set when the table is loaded.
    var titleTextField: UITextField?
    
    var currentEvent: Event = EventPopulator().createRandomEvents(count: 1).first!
    
    /// The delegate is informed of completion and cancelation.
    weak var delegate: AddEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavBarItem()
        configurePreviewCell()
        configurePreviewTableView()
        configureInputTableView()
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
    
    func configureInputTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = false
        tableView.dataSource = self
        
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "Title")
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePicker")
        
        inputTableView = tableView
        view.addSubview(inputTableView)
    }
    
    func setUpConstraints() {
        previewTableView.translatesAutoresizingMaskIntoConstraints = false
        inputTableView.translatesAutoresizingMaskIntoConstraints = false
        
        inputTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        inputTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        inputTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        inputTableView.bottomAnchor.constraint(equalTo: previewTableView.topAnchor, constant: 0).isActive = true
        
        previewTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        previewTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        safeAreaConstraint = previewTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        safeAreaConstraint?.isActive = true
    }
    
    func refreshPreviewCell() {
        guard let previewCell = previewCell else { return }
        cellConfigurer.configureCell(previewCell, using: currentEvent.nextReminder(using: cellConfigurer.calender))
    }
    
    // MARK: TableView Data Source
    
    enum Section: Int {
        case title, date//, icon, type, fequency
        static let caseCount = 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.caseCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        guard let section = Section(rawValue: index) else { fatalError("Unexpected section index. You probably forgot to add a case to row.") }
        switch section {
        case .title:
            return "Title"
        case.date:
            return "Date"
        }
    }
    
    func reuseIdentifier(for indexPath: IndexPath) -> String {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected section index. You probably forgot to add a case to row.") }
        switch section {
        case .title:
            return "Title"
        case.date:
            return "DatePicker"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected section index. You probably forgot to add a case to row.") }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(for: indexPath)) else {
            fatalError("Could not load nib. Did you make the table view cell the only top level object?")
        }
        
        switch section {
        case .title:
            let textFieldCell = cell as! TextFieldTableViewCell
            titleTextField = textFieldCell.textField
            textFieldCell.textField.placeholder = "i.e. Joseph Van Boxtel"
            titleTextField?.addTarget(self, action: #selector(finishedEditing(_:)), for: .editingDidEndOnExit)
            
        case .date:
            let datePickerCell = cell as! DatePickerTableViewCell
            datePicker = datePickerCell.datePicker
            datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
        return cell
    }
    
    // MARK: Actions

    /// Send when the titleTextField presses the return key.
    @IBAction func finishedEditing(_ sender: UITextField) {
        titleTextField?.resignFirstResponder()
        guard let titleText = titleTextField?.text else { return }
        // Change the title on the current event.
        currentEvent = Event(title: titleText, iconName: currentEvent.iconName, date: currentEvent.date, lengthType: currentEvent.lengthType, reminderFrequency: currentEvent.reminderFrequency)
        refreshPreviewCell()
    }
    
    /// Send when the datePicker's value changes.
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        guard let date = datePicker?.date else { return }
        // Change the date on the current event.
        currentEvent = Event(title: currentEvent.title, iconName: currentEvent.iconName, date: date, lengthType: currentEvent.lengthType, reminderFrequency: currentEvent.reminderFrequency)
        refreshPreviewCell()
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
