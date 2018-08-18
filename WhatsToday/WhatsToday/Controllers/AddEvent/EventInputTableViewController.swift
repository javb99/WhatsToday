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
    
    var dateLabel: UILabel?
    
    var date: Date = Date()
    
    /// The text field in the cell for the title. Set when the table is loaded.
    var titleTextField: UITextField?
    
    var isEditingDate: Bool = false {
        didSet {
            if oldValue != isEditingDate {
                tableView.reloadSections([1], with: .automatic)
                if isEditingDate {
                    titleTextField?.resignFirstResponder()
                    
                    // Scroll the date label and picker to be visible. Doesn't always work yet.
                    let labelRect = tableView.rectForRow(at: IndexPath(row: 0, section: Section.date.rawValue))
                    let pickerRect = tableView.rectForRow(at: IndexPath(row: 1, section: Section.date.rawValue))
                    tableView.scrollRectToVisible(labelRect.union(pickerRect), animated: true)
                }
            }
        }
    }
    
    /// Format: March 3, 2018
    static let longDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "Title")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Date")
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePicker")
    }
    
    // MARK: Actions
    
    @IBAction func beganEditing(_ sender: UITextField) {
        isEditingDate = false
    }
    
    /// Send when the titleTextField presses the return key.
    @IBAction func finishedEditing(_ sender: UITextField) {
        titleTextField?.resignFirstResponder()
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        guard let titleText = titleTextField?.text else { return }
        delegate?.titleChanged(titleText)
    }
    
    /// Send when the datePicker's value changes.
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        guard let date = datePicker?.date else { return }
        self.date = date
        delegate?.dateChanged(date)
        dateLabel?.text = EventInputTableViewController.longDateFormatter.string(for: date)
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            isEditingDate = !isEditingDate
        }
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
        guard let section = Section(rawValue: section) else { fatalError("Unexpected section index. You probably forgot to add a case to row.") }
        
        if section == .date && isEditingDate {
            return 2
        } else {
            return 1
        }
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
            return indexPath.row == 0 ? "Date" : "DatePicker"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected section index. You probably forgot to add a case to row.") }
        guard var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(for: indexPath)) else {
            fatalError("Could not load nib. Did you make the table view cell the only top level object?")
        }
        
        switch section {
        case .title:
            let textFieldCell = cell as! TextFieldTableViewCell
            titleTextField = textFieldCell.textField
            textFieldCell.textField.placeholder = "i.e. Joseph Van Boxtel"
            titleTextField?.addTarget(self, action: #selector(beganEditing(_:)), for: .editingDidBegin)
            titleTextField?.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
            titleTextField?.addTarget(self, action: #selector(finishedEditing(_:)), for: .editingDidEndOnExit)
            
        case .date where indexPath.row == 0:
            cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.detailTextLabel?.text = EventInputTableViewController.longDateFormatter.string(for: date)
            dateLabel = cell.detailTextLabel
            dateLabel?.textColor = isEditingDate ? ColorAssets.appTint : .darkText
            datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            
        case .date:
            let datePickerCell = cell as! DatePickerTableViewCell
            datePicker = datePickerCell.datePicker
            datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
        return cell
    }
}
