//
//  Label.swift
//  Base
//
//  Created by Hoàng Anh on 30/07/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import UIKit.UILabel

extension UILabel {
    convenience init(text: String = "", fontSize: CGFloat = 17, color: UIColor = .black, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        font = .systemFont(ofSize: fontSize)
        textColor = color
        self.textAlignment = textAlignment
    }
}

final class Label: UILabel {
    
    @IBInspectable
    var localizeText: String = "" {
        didSet {
            text = localizeText.localized
        }
    }
    
    @IBInspectable
    var isStrikethrough: Bool = false {
        didSet {
            styleText()
        }
    }
    
    @IBInspectable
    var isUnderlined: Bool = false {
        didSet {
            styleText()
        }
    }
    
    @IBInspectable
    var spacing: Float = 0.0 {
        didSet {
            styleText()
        }
    }
    
    @IBInspectable
    var linedSpacing: CGFloat = 1 {
        didSet {
            styleText()
        }
    }
    
    override var text: String? {
        didSet {
            super.text = text
            styleText()
        }
    }
    
    override func awakeFromNib() {
        if (text ?? "").isActuallyEmpty {
            styleText()
        }
    }
    
    private func styleText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = linedSpacing
        paragraphStyle.alignment = textAlignment
        
        var attributes: [NSAttributedString.Key: Any] = [
            .kern: spacing,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColor as Any,
            .font: font as Any,
            .strikethroughStyle: isStrikethrough ? 1 : 0
        ]
        if isUnderlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let attributedString = NSAttributedString(string: text ?? "", attributes: attributes)
        
        attributedText = attributedString
    }
}
