//
//  HeadlineLabelSetView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit

final class VerticalLabelsStackView: UIStackView {
    
    var titleLabel: Label
    
    var subtitleLabel: Label
    
    enum _Type {
        case regular
        case small
    }
    
    var type: _Type = .regular {
        didSet {
            setupTheme()
        }
    }
    
    var textAlignment: NSTextAlignment = .natural {
        didSet {
            setTextAlignment()
        }
    }
    
    init(title: String = " ",
         subtitle: String? = nil,
         textAlignment: NSTextAlignment = .natural) {
        titleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        setupView()
        setupTheme()
        setupValue(title: title, subtitle: subtitle)
        self.textAlignment = textAlignment
        setTextAlignment()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
    
    private func setTextAlignment() {
        titleLabel.textAlignment = textAlignment
        subtitleLabel.textAlignment = textAlignment
    }
    
    func setupTheme() {
        titleLabel.textColor = .text
        subtitleLabel.textColor = .subtext
        
        let headerSize: CGFloat = type == .regular ? 16 : 13
        
        titleLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: headerSize, weight: .regular))
        subtitleLabel.font = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: .systemFont(ofSize: 10, weight: .medium))
        spacing = 3
        setTextAlignment()
    }
    
    func setupValue(title: String,
                          subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
