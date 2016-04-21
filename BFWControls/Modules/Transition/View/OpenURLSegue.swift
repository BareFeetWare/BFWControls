//
//  OpenURLSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 21/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class OpenURLSegue: UIStoryboardSegue {

    override func perform() {
        let title = destinationViewController.navigationItem.title ?? destinationViewController.title
        if let urlString = title,
            let url = NSURL(string: urlString)
        {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("OpenURLSegue could not make a URL out of the title \"\(title)\"")
        }
    }
    
}
