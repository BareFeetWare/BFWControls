//
//  BackgroundNavigationController.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 19/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

import UIKit

class BackgroundNavigationController: UINavigationController {
    
    let backgroundView = BackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(backgroundView, at: 0)
        backgroundView.pinToSuperviewEdges()
    }
    
}
