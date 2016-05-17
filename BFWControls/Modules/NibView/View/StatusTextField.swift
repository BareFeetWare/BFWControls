//
//  StatusTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

enum ControlStatus: Int {
    
    case None = 0
    case Success = 1
    case Warning = 2
    case Error = 3
    
    var color: UIColor {
        switch self {
        case .None:
            return UIColor.blackColor()
        case .Success:
            return UIColor.greenColor()
        case .Warning:
            return UIColor.yellowColor()
        case .Error:
            return UIColor.redColor()
        }
    }
    
}

class StatusTextField: NibTextField {

    // MARK: - Variables

    var status: ControlStatus = .None { didSet { setNeedsUpdateView() }}
    
    // MARK: - IBInspectable mapping to variables
    
    @IBInspectable var status_: Int {
        get {
            return status.rawValue
        }
        set {
            status = ControlStatus(rawValue: newValue) ?? .None
        }
    }
    
    // MARK: - NibTextField

    override func updateView() {
        super.updateView()
        contentView.iconView?.hidden = status == .None
        contentView.iconView?.tintColor = status.color
        contentView.detailTextLabel?.textColor = status.color
    }

}
