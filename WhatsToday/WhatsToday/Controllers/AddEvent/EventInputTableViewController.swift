//
//  EventInputTableViewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

/// The delegate is notified of changes to each field.
protocol EventInputDelegate: class {
    func titleChanged(_ newTitle: String)
    func dateChanged(_ newDate: Date)
}

class EventInputTableViewController: UITableViewController {
    
    weak var delegate: EventInputDelegate?
    
    /// The date picker in the cell for the date.
    var datePicker: UIDatePicker?
    
    /// The text field in the cell for the title. Set when the table is loaded.
    var titleTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.dataSource = self
        
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "Title")
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePicker")
    }
    
    // MARK: Actions
    
    /// Send when the titleTextField presses the return key.
    @IBAction func finishedEditing(_ sender: UITextField) {
        titleTextField?.resignFirstResponder()
        guard let titleText = titleTextField?.text else { return }
        delegate?.titleChanged(titleText)
    }
    
    /// Send when the datePicker's value changes.
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        guard let date = datePicker?.date else { return }
        delegate?.dateChanged(date)
    }
    
    // MARK: TableView Data Source
    
    enum Section: Int {
        case title, date//, icon, type, fequency
        static let caseCount = 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.caseCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
