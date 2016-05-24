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
            return UIColor.grayColor()
        case .Success:
            return UIColor.greenColor()
        case .Warning:
            return UIColor.yellowColor()
        case .Error:
            return UIColor.redColor()
        }
    }
    
}

class StatusTextField: NibTextField, UITextFieldDelegate {

    // MARK: - Variables

    var status: ControlStatus = .None { didSet { setNeedsUpdateView() }}
    
    private var statusTextFieldNibView: StatusTextFieldNibView? {
        return contentView as? StatusTextFieldNibView
    }
    
    // MARK: - IBInspectable mapping to contentView Nib

    @IBInspectable var message: String? {
        get {
            return statusTextFieldNibView?.messageLabel?.text
        }
        set {
            statusTextFieldNibView?.messageLabel?.text = newValue
        }
    }
    
    // MARK: - IBInspectable mapping to variables
    
    @IBInspectable var status_: Int {
        get {
            return status.rawValue
        }
        set {
            status = ControlStatus(rawValue: newValue) ?? .None
        }
    }

    // MARK: - Init

    override func commonInit() {
        super.commonInit()
        statusTextFieldNibView?.titleLabel?.text = nil
        message = nil
        status = .None
        super.delegate = self
    }
    
    // MARK: - updateView

    override func updateView() {
        super.updateView()
        statusTextFieldNibView?.iconView?.hidden = status == .None
        statusTextFieldNibView?.iconView?.tintColor = status.color
        statusTextFieldNibView?.borderView?.backgroundColor = status.color
        statusTextFieldNibView?.messageLabel?.textColor = status.color
    }

    // MARK: - UITextFieldDelegate
    
    private var externalDelegate: UITextFieldDelegate?
    
    override var delegate: UITextFieldDelegate? {
        get {
            return externalDelegate
        }
        set {
            externalDelegate = newValue
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var should = true
        if let externalShould = externalDelegate?.textFieldShouldBeginEditing?(textField) {
            should = externalShould
        }
        return should
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        externalDelegate?.textFieldDidBeginEditing?(textField)
        statusTextFieldNibView?.titleLabel?.text = placeholder
        placeholder = nil // TODO: animate
    }

    func textFieldDidEndEditing(textField: UITextField) {
        externalDelegate?.textFieldDidEndEditing?(textField)
        placeholder = statusTextFieldNibView?.titleLabel?.text // TODO: animate
        statusTextFieldNibView?.titleLabel?.text = nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var should = true
        if let externalShould = externalDelegate?.textField?(textField,
                                                             shouldChangeCharactersInRange: range,
                                                             replacementString: string)
        {
            should = externalShould
        }
        if should {

        }
        return should
    }
    
}
