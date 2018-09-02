//
//  BoxedLabel.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/20/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

class BoxedLabel: UIView {
    
    private let textLabel: UILabel
    
    var insets: UIEdgeInsets
    
    // MARK: Passed on properties
    
    /// The radius to use when drawing rounded corners for the background. Animatable.
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// The current text that is displayed by the label.
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    
    /// The current styled text that is displayed by the label.
    var attributedText: NSAttributedString? {
        get {
            return textLabel.attributedText
        }
        set {
            textLabel.attributedText = newValue
        }
    }
    
    /// The color of the text.
    var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    
    /// The technique to use for aligning the text.
    var textAlignment: NSTextAlignment {
        get {
            return textLabel.textAlignment
        }
        set {
            textLabel.textAlignment = newValue
        }
    }
    
    /// The technique to use for wrapping and truncating the label’s text.
    var lineBreakMode: NSLineBreakMode {
        get {
            return textLabel.lineBreakMode
        }
        set {
            textLabel.lineBreakMode = newValue
        }
    }
    
    /// The font used to display the text.
    var font: UIFont {
        get {
            return textLabel.font
        }
        set {
            textLabel.font = newValue
        }
    }
    
    
    init(insets: UIEdgeInsets = .zero, cornerRadius: CGFloat = 8, backgroundColor: UIColor = .blue) {
        textLabel = UILabel(frame: .zero)
        self.insets = insets
        
        super.init(frame: .zero)
        
        self.cornerRadius = cornerRadius
        self.textColor = .white
        self.backgroundColor = backgroundColor
        
        addSubview(textLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.constrainFillSuperview(insets)
    }
}
