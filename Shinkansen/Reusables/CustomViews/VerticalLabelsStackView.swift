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
        subtitleLabel.textColor = .text
        titleLabel.font = .systemFont(ofSize: 34, weight: .light)
        subtitleLabel.font = .systemFont(ofSize: 16)
        spacing = 3
        setTextAlignment()
    }
    
    func setupValue(title: String,
                          subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
