//
//  UIViewController+Unwind.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 17/6/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

public extension UIViewController {
        
    var frontViewController: UIViewController {
        let frontViewController = presentedViewController
            ?? navigationController?.topViewController
            ?? (self as? UINavigationController)?.topViewController
            ?? self
        return frontViewController == self
            ? self
            : frontViewController.frontViewController
    }

    func unwindToSelf(animated: Bool, completion: (() -> Void)? = nil) {
        if let _ = presentedViewController {
            dismiss(animated: animated) { [weak self] in
                guard let strongSelf = self
                    else { return }
                strongSelf.popToRoot(animated: animated)
                completion?()
            }
        } else {
            popToRoot(animated: animated)
            completion?()
        }
    }
    
    private func popToRoot(animated: Bool) {
        if let navigationController = self as? UINavigationController
            ?? navigationController
        {
            navigationController.popToRootViewController(animated: animated)
        }
        
    }
    
}
