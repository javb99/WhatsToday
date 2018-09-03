//
//  EventCellPreviewController.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public class EventCellPreviewViewController: UITableViewController {
    
    /// The cell to use for the preview.
    public private(set) var previewCell: EventTableViewCell!
    
    /// The CellConfigurer responsible for configuring the previewCell.
    public let cellConfigurer = EventCellConfigurer()
    
    /// Needed to keep a strong reference to the data source.
    public var previewDataSource: ArrayDataSource!
    
    public var currentEvent: Event = EventPopulator().createRandomEvents(count: 1).first! {
        didSet {
            refreshPreviewCell()
        }
    }
    
    public override func loadView() {
        tableView = IntrinsicTableView(frame: .zero, style: .plain)
        view = tableView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePreviewCell()
        
        previewDataSource = ArrayDataSource(sections: [[previewCell]], headerTitles: ["Preview"])
        tableView.dataSource = previewDataSource
        
        tableView.isUserInteractionEnabled = false
        
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.lightGray
        
        refreshPreviewCell()
    }
    
    private func configurePreviewCell() {
        let previewCell = EventTableViewCell()
        
        self.previewCell = previewCell
    }
    
    public func refreshPreviewCell() {
        guard let previewCell = previewCell else { return }
        cellConfigurer.configureCell(previewCell, using: currentEvent.nextReminder(using: cellConfigurer.calender))
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
