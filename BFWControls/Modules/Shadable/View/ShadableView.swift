//
//  ShadableView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/7/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// UIView for grouping subviews under a single Shadable setting. eg view for a UINavigationController subclass.
open class ShadableView: UIView, Shadable {

    @IBInspectable open var isLight: Bool = false
    @IBInspectable open var isLightAuto: Bool = true

}
