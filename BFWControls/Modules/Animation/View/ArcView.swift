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
    
    @IBInspectable open var start: Double = 0.0 { didSet { setNeedsDraw() }}
    @IBInspectable open var end: Double = 1.0 { didSet { setNeedsDraw() }}
    @IBInspectable open var offset: Double = 0.0 { didSet { setNeedsDraw() }}
    @IBInspectable open var lineWidth: CGFloat = 2.0 { didSet { setNeedsDraw() }}
    @IBInspectable open var duration: Double = 1.0
    @IBInspectable open var fillColor: UIColor = .clear { didSet { setNeedsDraw() }}
    @IBInspectable open var strokeColor: UIColor = .gray { didSet { setNeedsDraw() }}
    
    @IBInspectable open var clockwise: Bool {
        get {
            return overriddenClockwise ?? (start < end)
        }
        set {
            overriddenClockwise = newValue
        }
    }
    
    @IBInspectable open var animationCurveInt: Int {
        get {
            return animationCurve.rawValue
        }
        set {
            animationCurve = UIView.AnimationCurve(rawValue: newValue) ?? .linear
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
    
    open var animationCurve: UIView.AnimationCurve = .linear
    
    open var bezierPath: UIBezierPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: min(bounds.midX, bounds.midY) - lineWidth / 2,
            startAngle: CGFloat(start + offset) * 2 * .pi,
            endAngle: CGFloat(end + offset) * 2 * .pi,
            clockwise: clockwise
        )
    }
    
    let shapeLayer = CAShapeLayer()
    
    private var overriddenClockwise: Bool?
    private var needsDraw = true
    
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
    
    private func updateShapeLayer() {
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
    }
    
    open func draw() {
        updateShapeLayer()
        #if TARGET_INTERFACE_BUILDER
        shapeLayer.strokeEnd = 1.0
        #else
        // Don't draw the arc initially
        shapeLayer.strokeEnd = 0.0
        animate()
        #endif
    }
    
    private func setNeedsDraw() {
        needsDraw = true
        setNeedsLayout()
    }
    
    private func drawIfNeeded() {
        if needsDraw {
            needsDraw = false
            draw()
        }
    }
    
    open func animate() {
        
        // Animate the strokeEnd property of the shapeLayer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        
        // Animate from 0 (no arc) to 1 (full arc)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = animationCurve.mediaTimingFunction
        
        // Set the shapeLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        shapeLayer.strokeEnd = 1.0
        
        // Do the actual animation
        shapeLayer.add(animation, forKey: "animate")
    }
    
    // MARK: UIView
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        drawIfNeeded()
    }
    
}

private extension UIView.AnimationCurve {
    
    var mediaTimingFunctionName: CAMediaTimingFunctionName {
        switch self {
        case .linear: return .linear
        case .easeIn: return .easeIn
        case .easeOut: return .easeOut
        case .easeInOut: return .easeInEaseOut
        @unknown default: fatalError("Unknown UIView.AnimationCurve: \(self)")
        }
    }
    
    var mediaTimingFunction: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: mediaTimingFunctionName)
    }
    
}
