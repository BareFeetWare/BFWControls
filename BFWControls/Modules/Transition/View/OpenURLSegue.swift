//
//  OpenURLSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 21/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class OpenURLSegue: UIStoryboardSegue {
    
    open override func perform() {
        guard let title = destination.navigationItem.title ?? destination.title,
            let url = URL(string: title)
            else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
