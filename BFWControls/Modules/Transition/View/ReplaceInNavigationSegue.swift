//
//  ReplaceInNavigationSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/7/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class ReplaceInNavigationSegue: UIStoryboardSegue {

    open override func perform() {
        guard var viewControllers = source.navigationController?.viewControllers
            else { return }
        viewControllers[viewControllers.count - 1] = destination.readiedForPush
        source.navigationController?.viewControllers = viewControllers
    }
    
}
