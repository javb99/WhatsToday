//
//  EventTableViewCell.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public class EventTableViewCell: UITableViewCell {
    
    static let standardEventIdentifier = "StandardEvent"
    static let standardEventNib = UINib(nibName: "EventTableViewCell", bundle: nil)
    static let closeEventIdentifier = "CloseEvent"
    static let closeEventNib = UINib(nibName: "CloseEventTableViewCell", bundle: nil)
    
    @IBOutlet public weak var titleLabel: UILabel!
    /// nil, if loaded from CloseEventTableViewCell.nib
    @IBOutlet public weak var dateLabel: UILabel?
    @IBOutlet public weak var daysLabel: UILabel!
    /// nil, if loaded from CloseEventTableViewCell.nib
    @IBOutlet public weak var daysAwayText: UILabel?
    @IBOutlet public weak var lengthLabel: UILabel!
    @IBOutlet public weak var typeIconView: UIImageView!
    /// nil, if loaded from CloseEventTableViewCell.nib
    @IBOutlet public weak var dateBackgroundView: UIView?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        /// Configure attributes that will be static.
        
        lengthLabel.textColor = UIColor.darkGray
        
        dateLabel?.textColor = .white
        dateBackgroundView?.layer.cornerRadius = 8
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
