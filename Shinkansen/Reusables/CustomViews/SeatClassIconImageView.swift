//
//  SeatClassIconImageView.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 08/03/2021.
//

import UIKit

extension SeatClassType {
    func image() -> UIImage {
        switch self {
        case .granClass:
            return #imageLiteral(resourceName: "gran")
        case .green:
            return #imageLiteral(resourceName: "green")
        case .ordinary:
            return #imageLiteral(resourceName: "ordinary")
        }
    }
    
    func iconImage() -> UIImage {
        switch self {
        case .granClass:
            return #imageLiteral(resourceName: "Icon Gran").withRenderingMode(.alwaysTemplate)
        case .green:
            return #imageLiteral(resourceName: "Icon Green Car").withRenderingMode(.alwaysTemplate)
        case .ordinary:
            return #imageLiteral(resourceName: "Icon Ordinary").withRenderingMode(.alwaysTemplate)
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .granClass:
            return UIColor.seatClass.granClass
        case .green:
            return UIColor.seatClass.green
        case .ordinary:
            return UIColor.seatClass.ordinary
        }
    }
}

enum IconSize {
    case regular
    case small
    
    func width() -> CGFloat {
        switch self {
        case .regular:
            return 24
        case .small:
            return 16
        }
    }
}

final class SeatClassIconImageView: UIImageView {
    
    private(set) var seatClass: SeatClassType {
        didSet {
            image = seatClass.iconImage()
        }
    }
    
    private(set) var iconSize: IconSize
    
    var isAvailable: Bool = true {
        didSet {
            setupTheme()
        }
    }
    
    init(seatClass: SeatClassType,
         iconSize: IconSize) {
        self.seatClass = seatClass
        self.iconSize = iconSize
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: iconSize.width()).isActive = true
        contentMode = .scaleAspectFit
        image = seatClass.iconImage()
    }
    
    public func setupTheme() {
        tintColor = isAvailable ? seatClass.color() : .appGray
        alpha = isAvailable ? 1 : 0.54
    }
    
    public func setSeatClass(to seatClass: SeatClassType) {
        self.seatClass = seatClass
    }
}
