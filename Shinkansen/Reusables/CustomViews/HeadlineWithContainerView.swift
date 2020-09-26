//
//  HeadlineWithContainerView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 25/09/2020.
//

import UIKit

final class HeadlineWithContainerView: UIStackView {
    
    var titleLabel: Label
    
    var view: UIView
    
    convenience init(title: String, containingView view: UIView) {
        self.init(containingView: view)
        setTitle(title: title)
    }
    
    init(containingView view: UIView) {
        titleLabel = Label()
        self.view = view
        super.init(frame: .zero)
        
        setupView()
        setupTheme()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 10
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(view)
    }
    
    func setupTheme() {
        titleLabel.textColor = .subtext
        titleLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for:
                                                                                UIFont.systemFont(ofSize: 11, weight: .medium), maximumPointSize: 16)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title.uppercased()
    }
}
