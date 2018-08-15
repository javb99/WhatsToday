//
//  EventTableViewCell.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public class EventTableViewCell: UITableViewCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var daysLabel: UILabel!
    @IBOutlet public weak var daysAwayText: UILabel!
    @IBOutlet public weak var lengthLabel: UILabel!
    @IBOutlet public weak var typeIconView: UIImageView!
    @IBOutlet public weak var dateBackgroundView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
