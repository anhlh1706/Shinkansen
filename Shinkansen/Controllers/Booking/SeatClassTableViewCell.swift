//
//  SeatClassTableViewCell.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import UIKit
import Anchorage

final class SeatClassTableViewCell: UITableViewCell {
    var cardView: TouchableControl
    var seatClassIconImageView: SeatClassIconImageView
    var seatClassNameSetView: VerticalLabelsStackView
    var descriptionLabel: Label
    var seatImageView: UIImageView
    
    var basedHeight: CGFloat = 108 {
        didSet {
            setupTheme()
        }
    }
    
    private var seatImageViewHeightConstraint: NSLayoutConstraint?
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cardView = TouchableControl()
        seatClassNameSetView = VerticalLabelsStackView()
        seatClassIconImageView = SeatClassIconImageView(seatClass: .granClass,
                                                        iconSize: .regular)
        descriptionLabel = Label()
        seatImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        contentView.isUserInteractionEnabled = false
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let seatClassIconContainerView = UIView()
        seatClassIconContainerView.addSubview(seatClassIconImageView)
        seatClassIconImageView.topAnchor == seatClassIconContainerView.topAnchor + 2
        seatClassIconImageView.horizontalAnchors == seatClassIconContainerView.horizontalAnchors
        
        let textContentStackView = UIStackView([seatClassNameSetView, descriptionLabel],
                                               axis: .vertical,
                                               distribution: .fill,
                                               alignment: .fill,
                                               spacing: 10)
        
        let mainContentStackView = UIStackView([seatClassIconContainerView, textContentStackView],
                                               distribution: .fill,
                                               alignment: .fill,
                                               spacing: 10)
        
        seatClassIconImageView.topAnchor == seatClassNameSetView.topAnchor
        
        cardView.contentView.addSubview(mainContentStackView)
        mainContentStackView.topAnchor == cardView.contentView.topAnchor + 12
        mainContentStackView.leadingAnchor == cardView.contentView.leadingAnchor + 16
        
        cardView.contentView.addSubview(seatImageView)
        seatImageView.verticalAnchors == cardView.contentView.verticalAnchors
        seatImageView.trailingAnchor == cardView.contentView.trailingAnchor - 16
        seatImageView.leadingAnchor == mainContentStackView.trailingAnchor + 10
        
        seatImageViewHeightConstraint = seatImageView.heightAnchor == CGFloat(basedHeight)
        seatImageViewHeightConstraint?.isActive = true
        seatImageView.widthAnchor == seatImageView.heightAnchor * 4 / 5
        
        seatImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .vertical)
        seatImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
        
        seatImageView.image = nil
        seatImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(cardView)
        cardView.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 4, left: 16, bottom: 12, right: 16)
        
        // MARK: Set views' properties
        descriptionLabel.numberOfLines = 0
    }
    
    func setupTheme() {
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .subtext
        descriptionLabel.lineBreakMode = .byTruncatingTail
        seatImageViewHeightConstraint?.constant = CGFloat(basedHeight)
    }
    
    func setupValue(seatClassType: SeatClassType,
                    seatClassName: String,
                    price: String? = nil,
                    description: String? = nil,
                    seatImage: UIImage? = nil) {
        seatClassIconImageView.setSeatClass(to: seatClassType)
        seatClassNameSetView.setupValue(title: seatClassName, subtitle: price)
        descriptionLabel.text = description
        seatImageView.image = seatImage
        setupTheme()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cardView.isHighlighted = highlighted
    }
}
