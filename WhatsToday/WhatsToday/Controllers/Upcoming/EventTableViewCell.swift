//
//  EventTableViewCell.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

public class EventTableViewCell: UITableViewCell {
    
    public static let standardEventIdentifier = "StandardEvent"
    public static let closeEventIdentifier = "CloseEvent"
    
    public var style: Style {
        didSet {
            update(for: style)
        }
    }
    
    public let titleLabel: UILabel
    public let daysLabel: UILabel
    public let lengthLabel: UILabel
    public let iconView: UIImageView
    
    public let dayGroupView: UIView
    
    public let dateLabel: BoxedLabel
    public let daysAwayText: UILabel
    
    private var standardConstraints: [NSLayoutConstraint] = []
    private var closeConstraints: [NSLayoutConstraint] = []
    
    public enum Style {
        case standard
        case close
    }
    
    public init() {
        self.style = .standard
        
        titleLabel = UILabel(frame: .zero)
        daysLabel = UILabel(frame: .zero)
        lengthLabel = UILabel(frame: .zero)
        iconView = UIImageView(image: nil)
        dateLabel = BoxedLabel()
        daysAwayText = UILabel(frame: .zero)
        dayGroupView = UIView()
        
        super.init(style: .default, reuseIdentifier: nil)
        
        addSubviews()
        setupSubviews()
        setupConstraints()
        
        update(for: style)
    }
    
    public override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lengthLabel)
        contentView.addSubview(iconView)
        
        dayGroupView.addSubview(daysLabel)
        dayGroupView.addSubview(dateLabel)
        dayGroupView.addSubview(daysAwayText)
        contentView.addSubview(dayGroupView)
    }
    
    private func setupSubviews() {
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        lengthLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lengthLabel.textColor = UIColor.darkGray
        lengthLabel.lineBreakMode = .byTruncatingTail
        
        daysLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        daysAwayText.font = UIFont.preferredFont(forTextStyle: .caption2)
        daysAwayText.text = "Days\nAway"
        daysAwayText.numberOfLines = 2
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        UIView.disableAutoresizingMaskConstraints(views: contentView.subviews)
        UIView.disableAutoresizingMaskConstraints(views: dayGroupView.subviews)
        
        // The dayGroupView should avoid being compressed horizontally.
        daysLabel.setContentCompressionResistancePriority(.defaultHigh + 10, for: .horizontal)
        daysAwayText.setContentCompressionResistancePriority(.defaultHigh + 10, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh + 10, for: .horizontal)
        dayGroupView.setContentCompressionResistancePriority(.defaultHigh + 10, for: .horizontal)
        
        // Forces the title to go to multiple lines rather than truncate.
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 10, for: .vertical)
        
        // iconView constraints.
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: iconView.bottomAnchor, constant: 8)
        ])
        
        // titleLabel constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
        ])
        
        // lengthLabel constraints
        NSLayoutConstraint.activate([
            lengthLabel.firstBaselineAnchor.constraintEqualToSystemSpacingBelow(titleLabel.lastBaselineAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: lengthLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: lengthLabel.leadingAnchor)
        ])

        /// dayGroupView sibling constraints
        NSLayoutConstraint.activate([
            dayGroupView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.trailingAnchor.constraint(equalTo: dayGroupView.trailingAnchor, constant: 8),
            dayGroupView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: dayGroupView.bottomAnchor, constant: 8),
            dayGroupView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16),
            dayGroupView.leadingAnchor.constraint(greaterThanOrEqualTo: lengthLabel.trailingAnchor, constant: 16)
        ])

        /// dateLabel constraints
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: dayGroupView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dayGroupView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: dayGroupView.trailingAnchor)
        ])

        // daysLabel constraints
        NSLayoutConstraint.activate([
            daysLabel.leadingAnchor.constraint(equalTo: dayGroupView.leadingAnchor),
            daysLabel.topAnchor.constraint(equalTo: dayGroupView.topAnchor),
            daysLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor)
        ])

        // Constraints for the .close style
        closeConstraints = [daysLabel.trailingAnchor.constraint(equalTo: dayGroupView.trailingAnchor)]
        
        // Constraints for the .standard style. Only add if daysAwayText is visible.
        standardConstraints = [
            daysAwayText.leadingAnchor.constraint(equalTo: daysLabel.trailingAnchor),
            daysAwayText.trailingAnchor.constraint(equalTo: dayGroupView.trailingAnchor),
            daysLabel.centerYAnchor.constraint(equalTo: daysAwayText.centerYAnchor),
            daysLabel.topAnchor.constraint(equalTo: dayGroupView.topAnchor),
            daysLabel.heightAnchor.constraint(equalTo: daysAwayText.heightAnchor)
        ]
    }
    
    public func update(for style: Style) {
        switch style {
        case .standard:
            // Hide the "Days Away" text.
            NSLayoutConstraint.deactivate(closeConstraints)
            NSLayoutConstraint.activate(standardConstraints)
            daysAwayText.isHidden = false
        case .close:
            // Show the "Days Away" text.
            NSLayoutConstraint.deactivate(standardConstraints)
            NSLayoutConstraint.activate(closeConstraints)
            daysAwayText.isHidden = true
        }
    }
}
