//: [Previous](@previous)

import UIKit
import PlaygroundSupport

extension UIColor {
    /// Returns a brighter color by increasing brightnesss, and decreasing saturation.
    func brighterColor(by brightnessFactor: CGFloat) -> UIColor? {
        print("Brightening by \(brightnessFactor*100)%")
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            print("Could not convert to HSB color space.")
            return nil
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * (1 + brightnessFactor), alpha: alpha)
    }
}

func ithValue(i: Int, dividingRangeFrom lowerBound: CGFloat, lessThan upperBound: CGFloat, into pieces: Int) -> CGFloat {
    let range = upperBound - lowerBound
    let incrementPerPiece = range / CGFloat(pieces)
    return upperBound - CGFloat(i) * incrementPerPiece
}

class ColorDataSource: NSObject, UITableViewDataSource {
    
    func color(forDaysAway daysAway: Int) -> UIColor {
        let appTintColor = #colorLiteral(red: 0.01099999994, green: 0.3959999979, blue: 0.7540000081, alpha: 1)
        
        var dayPercent: CGFloat
        
        switch daysAway {
        case 0..<7: // Between 100% and 50% brighter
            dayPercent = ithValue(i: daysAway, dividingRangeFrom: 0.5, lessThan: 1.0, into: 7)
        case 7...31: // Between -20% and 50%
            dayPercent = ithValue(i: daysAway-7, dividingRangeFrom: -0.2, lessThan: 0.5, into: 24)
        case 32...90: // Between -40% and -20%
            dayPercent = ithValue(i: daysAway-32, dividingRangeFrom: -0.4, lessThan: -0.2, into: 58)
        default:
            dayPercent = -0.4
        }
        
        return appTintColor.brighterColor(by: dayPercent)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = color(forDaysAway: indexPath.row)
        
        return cell
    }
}

// Present the view controller in the Live View window
let tableViewController = UITableViewController()
let dataSource = ColorDataSource()
tableViewController.tableView.dataSource = dataSource
tableViewController.tableView.reloadData()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = tableViewController

//: [Next](@next)
