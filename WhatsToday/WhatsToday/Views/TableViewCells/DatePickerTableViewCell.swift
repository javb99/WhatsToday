//
//  DatePickerTableViewCell.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/17/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    
    let datePicker: UIDatePicker
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        datePicker = UIDatePicker(frame: .zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        
        selectionStyle = .none
        
        contentView.addSubview(datePicker)
    }
    
    func setupConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let top = datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        let bottom = datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        let leading = datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        let trailing = datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
}

