import UIKit
import PlaygroundSupport

extension UIView {
    
    static func disableAutoresizingMaskConstraints(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @discardableResult
    func constrainFillSuperview(_ insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            preconditionFailure("superview must not be nil.")
        }
        
        let top = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        let bottom = self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        let leading = self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        let trailing = self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        
        let constraints = [top, bottom, leading, trailing]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

class BoxedLabel: UIView {
    
    private let textLabel: UILabel
    
    var insets: UIEdgeInsets
    
    // MARK: Passed on properties
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return textLabel.attributedText
        }
        set {
            textLabel.attributedText = newValue
        }
    }
    
    var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return textLabel.textAlignment
        }
        set {
            textLabel.textAlignment = newValue
        }
    }
    
    var lineBreakMode: NSLineBreakMode {
        get {
            return textLabel.lineBreakMode
        }
        set {
            textLabel.lineBreakMode = newValue
        }
    }
    
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

class EventTableViewCell: UITableViewCell {
    
    static let standardEventIdentifier = "StandardEvent"
    static let closeEventIdentifier = "CloseEvent"
    
    var style: Style {
        didSet {
            update(for: style)
        }
    }
    
    let titleLabel: UILabel
    let daysLabel: UILabel
    let lengthLabel: UILabel
    let iconView: UIImageView
    
    let dayGroupView: UIView
    
    let dateLabel: BoxedLabel
    let daysAwayText: UILabel
    
    var standardConstraints: [NSLayoutConstraint] = []
    var closeConstraints: [NSLayoutConstraint] = []
    
    enum Style {
        case standard
        case close
    }
    
    init() {
        self.style = .standard
        
        titleLabel = UILabel(frame: .zero)
        daysLabel = UILabel(frame: .zero)
        lengthLabel = UILabel(frame: .zero)
        iconView = UIImageView(image: nil)
        dateLabel = BoxedLabel()
        daysAwayText = UILabel(frame: .zero)
        dayGroupView = UIView()
        
        super.init(style: .default, reuseIdentifier: "Hello")
        
        addSubviews()
        setupSubviews()
        setupConstraints()
        
        update(for: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lengthLabel)
        contentView.addSubview(iconView)
        
        dayGroupView.addSubview(daysLabel)
        dayGroupView.addSubview(dateLabel)
        dayGroupView.addSubview(daysAwayText)
        contentView.addSubview(dayGroupView)
    }
    
    func setupSubviews() {
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
    
    func setupConstraints() {
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
    
    func update(for style: Style) {
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

let cell = EventTableViewCell.init()
cell.titleLabel.text = "Joseph Van Boxtel"
cell.iconView.backgroundColor = .blue
cell.dateLabel.text = "Mar 3"
cell.daysLabel.text = "1"
cell.lengthLabel.text = "17th Birthday"

// Present the view controller in the Live View window
let controller = SingleCellDisplayController(cell: cell)
controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
controller.tableView.reloadData()
PlaygroundPage.current.liveView = cell
cell
