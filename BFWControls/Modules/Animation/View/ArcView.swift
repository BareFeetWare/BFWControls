//
//  ArcView.swift
//  BFWControls
//
//  Created by Danielle on 1/8/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class ArcView: UIView {
    
    // MARK: - IBInspectable variables

    @IBInspectable open var start: Double = 0.0
    @IBInspectable open var end: Double = 1.0
    @IBInspectable open var lineWidth: CGFloat = 2.0
    @IBInspectable open var duration: TimeInterval = 1.0
    @IBInspectable open var fillColor: UIColor = .clear
    @IBInspectable open var strokeColor: UIColor = .gray
    
    @IBInspectable open var animationCurveInt: Int {
        get {
            return animationCurve.rawValue
        }
        set {
            animationCurve = UIViewAnimationCurve(rawValue: newValue) ?? .linear
        }
    }
    
    @IBInspectable open var isPaused = false {
        didSet {
            if oldValue != isPaused {
                if !isPaused {
                    animate()
                }
            }
        }
    }
    
    // MARK: - Variables

    open var animationCurve: UIViewAnimationCurve = .linear
    
    open lazy var bezierPath: UIBezierPath = UIBezierPath(
        arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
        radius: min(self.bounds.midX, self.bounds.midY) - self.lineWidth / 2,
        startAngle: CGFloat(self.start) * 2 * .pi,
        endAngle: CGFloat(self.end) * 2 * .pi,
        clockwise: self.start < self.end
    )
    
    let shapeLayer = CAShapeLayer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        // Add the shapeLayer to the view's layer's sublayers
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Functions

    private func updateView() {
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        // Don't draw the arc initially
        shapeLayer.strokeEnd = 0.0
    }
    
    open func animate() {
        updateView()
        
        // Animate the strokeEnd property of the shapeLayer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        
        // Animate from 0 (no arc) to 1 (full arc)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = animationCurve.mediaTimingFunction
        
        // Set the shapeLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        shapeLayer.strokeEnd = 1.0
        
        // Do the actual animation
        shapeLayer.add(animation, forKey: "animate")
    }
    
    // MARK: UIView
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        animate()
    }
    
}

fileprivate extension UIViewAnimationCurve {
    
    var mediaTimingFunctionString: String {
        switch self {
        case .linear: return kCAMediaTimingFunctionLinear
        case .easeIn: return kCAMediaTimingFunctionEaseIn
        case .easeOut: return kCAMediaTimingFunctionEaseOut
        case .easeInOut: return kCAMediaTimingFunctionEaseInEaseOut
        }
    }
    
    var mediaTimingFunction: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: mediaTimingFunctionString)
    }

}
