//
//  UIView+Extensions.swift
//  Multibuddy
//
//  Created by Daniel Springer on 7/24/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//


import UIKit

extension UIView {
    //    enum GlowEffect: Float {
    //        case small = 0.4, normal = 2, big = 15
    //    }

    func doGlowAnimation(withColor color: UIColor/*, withEffect effect: GlowEffect = .big*/) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = .zero
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero

        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = Int.zero
        glowAnimation.toValue = 15
        glowAnimation.beginTime = CACurrentMediaTime()+0.3
        glowAnimation.duration = CFTimeInterval(1)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        //        glowAnimation.isRemovedOnCompletion = true
        glowAnimation.repeatCount = .infinity
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
