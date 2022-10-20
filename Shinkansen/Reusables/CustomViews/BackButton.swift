//
//  BackButton.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 28/09/2020.
//

import UIKit
import Anchorage

final class BackButton: UIControl {
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                playAnimation(to: isHighlighted ? .pullBack : .original, withDuration: 0.125)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.shapeView.alpha = (self?.isHighlighted ?? false) ? 0.54 : 1
                    self?.shapeView.transform.tx = (self?.isHighlighted ?? false) ? 6 : 0
                }
            }
        }
    }
    
    enum ArrowShape {
        case original
        case pullBack
        case pushedForward
        
        private var originalPath: CGPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 4, y: 12))
            path.addLine(to: CGPoint(x: 20, y: 12))
            
            path.move(to: CGPoint(x: 10, y: 6))
            path.addLine(to: CGPoint(x: 4, y: 12))
            path.addLine(to: CGPoint(x: 10, y: 18))
            return path.cgPath
        }
        
        private var pushedForwardPath: CGPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 1, y: 12))
            path.addLine(to: CGPoint(x: 20, y: 12))
            
            path.move(to: CGPoint(x: 10, y: 8))
            path.addLine(to: CGPoint(x: 1, y: 12))
            path.addLine(to: CGPoint(x: 10, y: 16))
            return path.cgPath
        }
        
        private var pulledBackPath: CGPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 8, y: 12))
            path.addLine(to: CGPoint(x: 20, y: 12))
            
            path.move(to: CGPoint(x: 12, y: 4))
            path.addLine(to: CGPoint(x: 8, y: 12))
            path.addLine(to: CGPoint(x: 12, y: 20))
            return path.cgPath
        }
        
        func getPath() -> CGPath {
            switch self {
            case .original:
                return originalPath
            case .pullBack:
                return pulledBackPath
            case .pushedForward:
                return pushedForwardPath
            }
        }
    }
    
    var currentArrowShape: ArrowShape = .original
    
    var shapeLayer: CAShapeLayer
    
    var shapeView: UIView
    
    init() {
        shapeLayer = CAShapeLayer()
        shapeView = UIView()
        super.init(frame: .zero)
        setupView()
        setupShapeLayer()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        shapeView.layer.addSublayer(shapeLayer)
        shapeView.sizeAnchors == CGSize(width: 24, height: 24)
        shapeView.isUserInteractionEnabled = false
        
        addSubview(shapeView)
        shapeView.centerAnchors == centerAnchors
        sizeAnchors == CGSize(width: 44, height: 44)
    }
    
    func setupShapeLayer() {
        shapeLayer.path = currentArrowShape.getPath()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
    }
    
    func setupTheme() {
        shapeLayer.strokeColor = UIColor.primary.cgColor
    }
    
    func playAnimation(to arrowShape: ArrowShape, withDuration duration: CFTimeInterval = 0.35) {
        shapeLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "path")
        
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0, 0, 1)
        animation.fromValue = shapeLayer.path
        animation.toValue = arrowShape.getPath()
        animation.isRemovedOnCompletion = true
        shapeLayer.add(animation, forKey: "ActualAnimation")
        CATransaction.commit()
        shapeLayer.path = arrowShape.getPath()
    }
    
    func setPath(to arrowShape: ArrowShape) {
        shapeLayer.removeAllAnimations()
        shapeLayer.path = arrowShape.getPath()
    }

}
