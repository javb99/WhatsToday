//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import WhatsTodayPlaygroundAccessible

/// A basic data source that colors the cells using the `EventCellConfigurer`'s `color(forDaysAway:)` method.
class ColorDataSource: NSObject, UITableViewDataSource {
    
    let configurer = EventCellConfigurer()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 365
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = configurer.color(forDaysAway: indexPath.row)
        
        return cell
    }
}

let tableViewController = UITableViewController()
let dataSource = ColorDataSource()
tableViewController.tableView.dataSource = dataSource
tableViewController.tableView.reloadData()
PlaygroundPage.current.liveView = tableViewController

//: [Next](@next)
