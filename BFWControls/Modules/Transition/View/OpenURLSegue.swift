//
//  OpenURLSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 21/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class OpenURLSegue: UIStoryboardSegue {

    override func perform() {
        let title = destination.navigationItem.title ?? destination.title
        if let urlString = title,
            let url = URL(string: urlString)
        {
            UIApplication.shared.openURL(url)
        } else {
            print("OpenURLSegue could not make a URL out of the title \"\(title)\"")
        }
    }
    
}
