//
//  DecayFunction.swift
//  Shinkansen
//
//  Created by Lê Hoàng Anh on 11/03/2022.
//

import UIKit

struct DecayFunction {
    
    static func timeToHalt(velocity: CGPoint) -> CFTimeInterval {
        let fps: Double = 1 / 60
        var i = 0
        
        var v = velocity
        while abs(v.x) > 0.1 || abs(v.y) > 0.1 {
            v = step(timeElapsed: fps, velocity: v).velocity
            i = i + 1
        }
        
        return Double(i) / 60
    }
    
    // Source: https://github.com/facebook/pop/blob/master/pop/POPDecayAnimationInternal.h
    static func step(timeElapsed: CFTimeInterval, velocity: CGPoint) -> (velocity: CGPoint, displacement: CGPoint) {
        let deceleration = 0.996
        
        let dt = timeElapsed * Double(1000.0)
        let kv = pow(deceleration, dt)
        let kx = deceleration * (1 - kv) / (1 - deceleration)
        
        let v0 = CGPoint(x: velocity.x / CGFloat(1000.0), y: velocity.y / CGFloat(1000.0))
        let vx = v0.x * CGFloat(kv) * CGFloat(1000.0)
        let vy = v0.y * CGFloat(kv) * CGFloat(1000.0)
        
        return (velocity: CGPoint(x: vx, y: vy), displacement: CGPoint(x: v0.x * CGFloat(kx), y: v0.y * CGFloat(kx)))
    }
}

