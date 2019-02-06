//
//  UIViewController+Segue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 21/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIViewController {
    
    func canPerformSegue(identifier: String) -> Bool {
        var can = false
        if let templates = self.value(forKey: "storyboardSegueTemplates") as? NSArray
        {
            let predicate = NSPredicate(format: "identifier=%@", identifier)
            let filteredtemplates = templates.filtered(using: predicate)
            can = !filteredtemplates.isEmpty
        }
        return can
    }
    
}
