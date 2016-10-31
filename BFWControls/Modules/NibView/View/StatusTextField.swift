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
        case normal = 0
        case editing = 1
        case success = 2
        case warning = 3
        case error = 4
    }
    
    // MARK: - Variables

    /// Leave as nil to have placeholder animate into title when text entered in field.
    @IBInspectable var title: String? {
        didSet {
            statusTextFieldNibView?.titleLabel?.text = title
        }
    }
    
    var status: ControlStatus = .normal { didSet { setNeedsUpdateView() }}

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
            status = ControlStatus(rawValue: newValue) ?? .normal
        }
    }

    // MARK: - Computed variables
    
    var messageColor: UIColor {
        return status.color
    }
    
    var borderStatus: ControlStatus {
        return status == .normal && isEditing ? .editing : status
    }
    
    // MARK: - Private variables
    
    fileprivate var externalDelegate: UITextFieldDelegate?
    
    fileprivate var isPlaceholderAtTitle: Bool {
        return !(text?.isEmpty ?? true)
    }
    
    fileprivate var statusTextFieldNibView: StatusTextFieldNibView? {
        return contentView as? StatusTextFieldNibView
    }
    
    // MARK: - Init

    override func commonInit() {
        super.commonInit()
        statusTextFieldNibView?.titleLabel?.text = nil
        message = nil
        status = .normal
        super.delegate = self
    }
    
    // MARK: - updateView

    override func updateView() {
        super.updateView()
        statusTextFieldNibView?.iconView?.isHidden = status == .normal
        statusTextFieldNibView?.iconView?.tintColor = status.color
        statusTextFieldNibView?.borderView?.backgroundColor = borderStatus.color
        statusTextFieldNibView?.messageLabel?.textColor = messageColor
        if title == nil {
            // TODO: Animate:
            if isPlaceholderAtTitle {
                statusTextFieldNibView?.titleLabel?.text = super.placeholder
            } else {
                statusTextFieldNibView?.titleLabel?.text = " " // Needs some text for AutoLayout positioning.
            }
        }
    }

    // MARK: - UITextField

    override var placeholder: String? {
        get {
            return isPlaceholderAtTitle && title == nil ? nil : super.placeholder
        }
        set {
            super.placeholder = newValue
        }
    }
    
}

private extension StatusTextField.ControlStatus {
    
    var color: UIColor {
        switch self {
        case .normal: return .gray
        case .editing: return UIColor(red: 255.0, green: 200.0, blue: 0.0, alpha: 1.0)
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var should = true
        if let externalShould = externalDelegate?.textFieldShouldBeginEditing?(textField) {
            should = externalShould
        }
        return should
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setNeedsUpdateView()
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setNeedsUpdateView()
        externalDelegate?.textFieldDidEndEditing?(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var should = true
        if let externalShould = externalDelegate?.textField?(textField,
                                                             shouldChangeCharactersIn: range,
                                                             replacementString: string)
        {
            should = externalShould
        }
        if should {
            setNeedsUpdateView()
        }
        return should
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var should = true
        if let externalDelegate = externalDelegate {
            should = externalDelegate.textFieldShouldReturn?(textField) ?? true
        } else {
            resignFirstResponder()
        }
        return should
    }

}
