import UIKit
import PlaygroundSupport
import WhatsTodayPlaygroundAccessible

let cell = EventTableViewCell()
cell.titleLabel.text = "Joseph Van Boxtel"
cell.iconView.image = UIImage(named: "giftBox", in: Bundle(for: EventTableViewCell.self), compatibleWith: nil)
cell.dateLabel.text = "Mar 3"
cell.daysLabel.text = "10"
cell.lengthLabel.text = "17th Birthday"

let controller = SingleCellDisplayController(cell: cell)
controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
controller.tableView.reloadData()
PlaygroundPage.current.liveView = cell
cell
