//
//  PushFirstSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 15/3/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class PushFirstSegue: UIStoryboardSegue {

    open override func perform() {
        source.navigationController?.pushViewController(destination.firstViewController, animated: true)
    }
    
}
