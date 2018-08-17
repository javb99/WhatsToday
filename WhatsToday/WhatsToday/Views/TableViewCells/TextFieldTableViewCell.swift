//
//  TextFieldTableViewCell.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/16/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    let textField: UITextField
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textField = UITextField(frame: .zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        textField.borderStyle = .none
        textField.isEnabled = true
        
        selectionStyle = .none
        
        contentView.addSubview(textField)
    }
    
    func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let bottom = textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        let leading = textField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        let trailing = textField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
    
    func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}
