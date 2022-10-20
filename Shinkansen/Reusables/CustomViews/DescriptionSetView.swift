//
//  DescriptionSetView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import UIKit
import Anchorage

class DescriptionSetView: UIStackView {
    
    var trainNumberSetView: SubheadlineLabelSetView
    
    var carNumberSetView: SubheadlineLabelSetView
    
    var seatNumberSetView: SubheadlineLabelSetView
    
    var priceSetView: SubheadlineLabelSetView
    
    init(trainNumber: String = " ",
         trainName: String? = nil,
         carNumber: String? = nil,
         className: String? = nil,
         seatNumber: String? = nil,
         price: String? = nil) {
        trainNumberSetView = SubheadlineLabelSetView(title: trainNumber, subtitle: trainName, textAlignment: .left)
        carNumberSetView = SubheadlineLabelSetView(title: carNumber ?? "", subtitle: className, textAlignment: .center)
        seatNumberSetView = SubheadlineLabelSetView(title: seatNumber ?? "", textAlignment: .center)
        priceSetView = SubheadlineLabelSetView(title: price ?? "", textAlignment: .right)
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        distribution = .equalSpacing
        addArrangedSubview(trainNumberSetView)
        addArrangedSubview(carNumberSetView)
        addArrangedSubview(seatNumberSetView)
        addArrangedSubview(priceSetView)
    }
    
    public func setupTheme() {
        trainNumberSetView.setupTheme()
        carNumberSetView.setupTheme()
        seatNumberSetView.setupTheme()
        priceSetView.setupTheme()
    }
    
    public func setupValue(trainNumber: String = " ",
                          trainName: String? = nil,
                          carNumber: String? = nil,
                          className: String? = nil,
                          seatNumber: String? = nil,
                          price: String? = nil) {
        trainNumberSetView.setupValue(title: trainNumber, subtitle: trainName)
        carNumberSetView.setupValue(title: carNumber ?? "", subtitle: className)
        carNumberSetView.isHidden = carNumber == nil && className == nil
        seatNumberSetView.setupValue(title: seatNumber ?? "")
        seatNumberSetView.isHidden = seatNumber == nil
        priceSetView.setupValue(title: price ?? "")
        priceSetView.isHidden = price == nil
    }
}

class SubheadlineLabelSetView: UIStackView {
    
    /// The label used for the main content.
    var titleLabel: Label
    
    /// The label used for the secondary content.
    var subtitleLabel: Label
    
    /// The technique to use for aligning the text in the set.
    var textAlignment: NSTextAlignment = .natural {
        didSet {
            setTextAlignment()
        }
    }
    
    fileprivate var subtitlePlaceholderLabel: Label
    
    fileprivate var subtitleHorizontalConstraint: NSLayoutConstraint?
    
    /// Initializes and returns a subheadline label set view.
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    ///   - textAlignment: The technique to use for aligning the text in the set.
    init(title: String = " ",
         subtitle: String? = nil,
         textAlignment: NSTextAlignment = .natural) {
        titleLabel = Label()
        subtitleLabel = Label()
        subtitlePlaceholderLabel = Label()
        subtitlePlaceholderLabel.text = " "
        super.init(frame: .zero)
        setupView()
        setupTheme()
        setupValue(title: title,
                  subtitle: subtitle)
        self.textAlignment = textAlignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitlePlaceholderLabel)
        addSubview(subtitleLabel)
        subtitleLabel.centerYAnchor == subtitlePlaceholderLabel.centerYAnchor
    }
    
    private func setTextAlignment() {
        titleLabel.textAlignment = textAlignment
        subtitleLabel.textAlignment = textAlignment
        
        if let constraint = subtitleHorizontalConstraint {
            removeConstraint(constraint)
        }
        
        switch textAlignment {
        case .left:
            subtitleHorizontalConstraint = subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        case .center:
            subtitleHorizontalConstraint = subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        case .right:
            subtitleHorizontalConstraint = subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        default:
            subtitleHorizontalConstraint = subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        subtitleHorizontalConstraint?.isActive = true
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        titleLabel.textColor = .text
        subtitleLabel.textColor = .subtext
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitlePlaceholderLabel.font = .preferredFont(forTextStyle: .caption1)
        spacing = CGFloat(2)
        setTextAlignment()
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    public func setupValue(title: String,
                          subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
