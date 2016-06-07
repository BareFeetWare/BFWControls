//
//  StatusTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class StatusTextField: NibTextField {

    // MARK: - Enum

    enum ControlStatus: Int {
        
        case None = 0
        case Editing = 1
        case Success = 2
        case Warning = 3
        case Error = 4
        
        var color: UIColor {
            switch self {
            case .None:
                return UIColor.grayColor()
            case .Editing:
                return UIColor(red: 255.0, green: 200.0, blue: 0.0, alpha: 1.0)
            case .Success:
                return UIColor.greenColor()
            case .Warning:
                return UIColor.orangeColor()
            case .Error:
                return UIColor.redColor()
            }
        }
        
    }
    
    // MARK: - Variables

    var status: ControlStatus = .None { didSet { setNeedsUpdateView() }}

    private var externalDelegate: UITextFieldDelegate?
    
    private var isPlaceholderAtTitle: Bool {
        return text?.characters.count > 0
    }

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
        var borderStatus = status
        if borderStatus == .None && editing {
            borderStatus = .Editing
        }
        statusTextFieldNibView?.borderView?.backgroundColor = borderStatus.color
        statusTextFieldNibView?.messageLabel?.textColor = status.color
        // TODO: Animate:
        if isPlaceholderAtTitle {
            statusTextFieldNibView?.titleLabel?.text = super.placeholder
        } else {
            statusTextFieldNibView?.titleLabel?.text = nil
        }
    }

    // MARK: - UITextField

    override var placeholder: String? {
        get {
            return isPlaceholderAtTitle ? nil : super.placeholder
        }
        set {
            super.placeholder = newValue
        }
    }

}

extension StatusTextField: UITextFieldDelegate {
    
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
        setNeedsUpdateView()
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        setNeedsUpdateView()
        externalDelegate?.textFieldDidEndEditing?(textField)
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
            setNeedsUpdateView()
        }
        return should
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var should = true
        if let externalDelegate = externalDelegate {
            should = externalDelegate.textFieldShouldReturn?(textField) ?? true
        } else {
            resignFirstResponder()
        }
        return should
    }

}
