//
//  TextLabelProvider.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 15/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public protocol TextLabelProvider {
    var textLabel: UILabel? { get }
    var detailTextLabel: UILabel? { get }
}
