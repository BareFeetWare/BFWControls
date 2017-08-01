//
//  ArcView.swift
//  BFWControls
//
//  Created by Danielle on 1/8/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable class ArcView: UIView {
    
    // MARK: - IBInspecatble variables

    @IBInspectable var start: CGFloat = -0.25
    @IBInspectable var end: CGFloat = 0.75
    @IBInspectable var lineWidth: CGFloat = 2
    @IBInspectable var duration: TimeInterval = 3.0
    @IBInspectable var fillColor: UIColor = .clear
    @IBInspectable var strokeColor: UIColor = .blue
    
    @IBInspectable var curveInt: Int {
        get {
            return curve.rawValue
        }
        set {
            curve = Curve(rawValue: newValue) ?? .linear
        }
    }
    
    @IBInspectable var isPaused = false {
        didSet {
            if oldValue != isPaused {
                if !isPaused {
                    animate()
                }
            }
        }
    }
    
    // MARK: - Enums

    enum Curve: Int {
        case linear = 0
        case easeIn
        case easeOut
        case easeInEaseOut
        
        var mediaTimingFunctionString: String {
            switch self {
            case .linear: return kCAMediaTimingFunctionLinear
            case .easeIn: return kCAMediaTimingFunctionEaseIn
            case .easeOut: return kCAMediaTimingFunctionEaseOut
            case .easeInEaseOut: return kCAMediaTimingFunctionEaseInEaseOut
            }
        }
        
        var mediaTimingFunction: CAMediaTimingFunction {
            return CAMediaTimingFunction(name: mediaTimingFunctionString)
        }
        
    }
    
    // MARK: - Variables

    var curve: Curve = .linear
    let arcLayer = CAShapeLayer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        // Add the arcLayer to the view's layer's sublayers
        layer.addSublayer(arcLayer)
    }
    
    // MARK: - Functions

    private func updateView() {
        let arcPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: min(bounds.midX, bounds.midY),
            startAngle: start * 2 * .pi,
            endAngle: end * 2 * .pi,
            clockwise: start < end
        )
        arcLayer.path = arcPath.cgPath
        arcLayer.fillColor = fillColor.cgColor
        arcLayer.strokeColor = strokeColor.cgColor
        arcLayer.lineWidth = lineWidth
        
        // Don't draw the arc initially
        arcLayer.strokeEnd = 0.0
    }
    
    func animate() {
        
        updateView()
        
        // Animate the strokeEnd property of the arcLayer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        
        // Animate from 0 (no arc) to 1 (full arc)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = curve.mediaTimingFunction
        
        // Set the arcLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        arcLayer.strokeEnd = 1.0
        
        // Do the actual animation
        arcLayer.add(animation, forKey: "animate")
    }
    
    // MARK: UIView
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        animate()
    }
    
}
