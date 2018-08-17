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

private extension ClosedRange where Bound: Strideable {
    /// The distance between the lower bound and upper bound.
    var length: Bound.Stride {
        return lowerBound.distance(to: upperBound)
    }
}

/// Splits the range into `count` equidistant values including `upperbound` and `lowerbound` and returns the ith value. So if you split the range from 10...20 into 11 would give the equidistant values [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].
private func ithEquidistantValue(i: Int, within range: ClosedRange<CGFloat>, count: Int) -> CGFloat {
    let incrementPerPiece = range.length / CGFloat(count-1)
    return range.upperBound - CGFloat(i) * incrementPerPiece
}

class ColorDataSource: NSObject, UITableViewDataSource {
    
    func color(forDaysAway daysAway: Int) -> UIColor {
        let appTintColor = #colorLiteral(red: 0.01099999994, green: 0.3959999979, blue: 0.7540000081, alpha: 1)
        
        var dayPercent: CGFloat
        
        switch daysAway {
        case 0..<7: // Between 100% and 50% brighter
            dayPercent = ithEquidistantValue(i: daysAway, within: 0.5...1.0, count: 7)
        case 7...31: // Between -20% and 50%
            dayPercent = ithEquidistantValue(i: daysAway-7, within: -0.2...0.5, count: 24)
        case 32...90: // Between -40% and -20%
            dayPercent = ithEquidistantValue(i: daysAway-32, within: -0.4...(-0.2), count: 58)
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
