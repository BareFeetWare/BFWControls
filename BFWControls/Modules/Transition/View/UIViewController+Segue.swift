//
//  UIViewController+Segue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 21/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func canPerformSegueWithIdentifier(identifier: NSString?) -> Bool {
        var can = false
        if let identifier = identifier,
            let templates = self.valueForKey("storyboardSegueTemplates") as? NSArray
        {
            let predicate = NSPredicate(format: "identifier=%@", identifier)
            let filteredtemplates = templates.filteredArrayUsingPredicate(predicate)
            can = !filteredtemplates.isEmpty
        }
        return can
    }
    
}