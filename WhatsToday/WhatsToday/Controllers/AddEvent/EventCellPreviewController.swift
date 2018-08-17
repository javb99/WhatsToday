//
//  EventCellPreviewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class EventCellPreviewViewController: UITableViewController {
    
    /// The cell to use for the preview.
    var previewCell: EventTableViewCell!
    
    /// The CellConfigurer responsible for configuring the previewCell.
    let cellConfigurer = EventCellConfigurer()
    
    /// Needed to keep a strong reference to the data source.
    var previewDataSource: ArrayDataSource!
    
    var currentEvent: Event = EventPopulator().createRandomEvents(count: 1).first! {
        didSet {
            refreshPreviewCell()
        }
    }
    
    override func loadView() {
        tableView = IntrinsicTableView(frame: .zero, style: .plain)
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePreviewCell()
        
        previewDataSource = ArrayDataSource(sections: [[previewCell]], headerTitles: ["Preview"])
        tableView.dataSource = previewDataSource
        
        tableView.isUserInteractionEnabled = false
        
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.lightGray
        
        refreshPreviewCell()
    }
    
    func configurePreviewCell() {
        let nib = EventTableViewCell.standardEventNib
        guard let previewCell = nib.instantiate(withOwner: nil, options: nil).first as? EventTableViewCell else {
            fatalError("Failed to load the nib. You must have changed something critical.")
        }
        
        self.previewCell = previewCell
    }
    
    func refreshPreviewCell() {
        guard let previewCell = previewCell else { return }
        cellConfigurer.configureCell(previewCell, using: currentEvent.nextReminder(using: cellConfigurer.calender))
    }
}
