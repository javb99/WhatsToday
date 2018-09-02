//
//  EventCellConfigurer.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/15/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

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

/// A structure to manage the configuration of EventTableViewCells.
struct EventCellConfigurer {
    
    /// Format: Mar 3
    static let monthAndDayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        return dateFormatter
    }()
    
    /// The calendar to use for calcuations. Defaults to Calendar.autoupdatingCurrent.
    let calender = Calendar.autoupdatingCurrent
    
    /// The tint color for the given number of days away.
    func color(forDaysAway daysAway: Int) -> UIColor {
        let appTintColor = ColorAssets.appTint
        
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
        
        return appTintColor.colorBrighter(by: dayPercent)!
    }
    
    /// Configures the given cell for the givent event.
    func configureCell(_ cell: EventTableViewCell, using upcomingEvent: Reminder) {
        let daysAway = calender.daysAway(from: upcomingEvent.date)
        
        // Sets the image on the left of the cell. For example, the gift box.
        cell.iconView.image = UIImage(named: upcomingEvent.originalEvent.iconName)
        
        // Sets the title. For birthdays it will probably be a name.
        cell.titleLabel.text = upcomingEvent.originalEvent.title
        
        // Set the subtitle.
        let yearsOld = calender.yearsBetween(upcomingEvent.originalEvent.date, upcomingEvent.date)
        cell.lengthLabel.text = "\(yearsOld) years old"
        
        // Color relevant elements
        let rowColor = color(forDaysAway: daysAway)
        cell.daysLabel.textColor = rowColor
        cell.iconView.tintColor = rowColor
        cell.dateLabel.backgroundColor = rowColor
        cell.daysAwayText.textColor = rowColor
        
        // Set the date label to a formatted date.
        cell.dateLabel.text = EventCellConfigurer.monthAndDayFormatter.string(from: upcomingEvent.date)
        
        // Set the days away label.
        var daysText: String
        switch daysAway {
            case 0:
                daysText = "Today"
                cell.style = .close
            case 1:
                daysText = "Tomorrow"
                cell.style = .close
            default:
                daysText = String(daysAway)
                cell.style = .standard
        }
        cell.daysLabel.text = daysText
    }
}
