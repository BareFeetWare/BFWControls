//
//  MorphSegue.swift
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

import UIKit

open class MorphSegue: UIStoryboardSegue {

    // MARK: - Public variables

    @IBOutlet open lazy var fromView: UIView? = {
        return self.source.view
    }()
    
    @IBInspectable var duration: TimeInterval = 1.0
    var animationOptions = UIViewAnimationOptions()
    
    // MARK: - UIStoryboardSegue
    
    open override func perform() {
        let destinationVCView = destination.view!
        let sourceVCView = source.view
        
        // Force frames to match constraints, in case misplaced.
        destinationVCView.setNeedsLayout()
        destinationVCView.layoutIfNeeded()
        
        destinationVCView.frame = (sourceVCView?.frame)!
        if let cell = fromView as? UITableViewCell {
            cell.isSelected = false
        }
        
        var morphingView: UIView?
        var contentView: UIView?
        let useCopyForMorphingView = true
        if useCopyForMorphingView {
            // Create a copy of the view hierarchy for morphing, so the original is not changed.
            if let cell = fromView as? UITableViewCell {
                morphingView = cell.copy(withSubviews: nil, includeConstraints: false)
                morphingView?.copySubviews(cell.contentView.subviews, includeConstraints: false)
            } else {
                morphingView = fromView?.copy(withSubviews: fromView?.subviews, includeConstraints: false)
            }
            if let morphingView = morphingView {
                sourceVCView?.addSubview(morphingView)
                morphingView.pinToSuperviewEdges()
                contentView = morphingView
            }
        } else {
            // morphingView = fromView
            // if let cell = fromView as? UITableViewCell {
            //     contentView = cell.contentView
            // }
            // TODO: finish
        }
        
        if let morphingView = morphingView {
            
            // Add destination constraints, which will animate frames when layout is updated, inside animation block below.
            morphingView.copyDescendantConstraints(from: destinationVCView)

            UIView.animate(
                withDuration: duration,
                delay: 0.0,
                options: animationOptions,
                animations: {
//                    morphingView.setNeedsLayout()
//                    morphingView.layoutIfNeeded()
                    if let _ = self.fromView as? UITableViewCell {
                        morphingView.frame = (sourceVCView?.bounds)!
                        contentView?.frame = morphingView.bounds
                    }
                    if let subviews = contentView?.subviews {
                        for subview in subviews {
                            if let destinationSubview = destinationVCView.subview(matching: subview) {
                                subview.frame = destinationSubview.superview!.convert(destinationSubview.frame, to: destinationVCView)
//                                subview.frame.origin.y += 64.0 // Nav bar hack
                                subview.copyAnimatableProperties(from: destinationSubview)
                            } else {
                                subview.alpha = 0.0
                            }
                        }
                    }
                })
                { finished in
                    self.source.navigationController?.pushViewController(self.destination,
                        animated: false)
                    if useCopyForMorphingView {
                        morphingView.removeFromSuperview()
                        // morphingView.hidden = true // Keep it for reverse animation?
                    }
            }
        }
    }
    
}
