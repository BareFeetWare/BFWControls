//
//  StatusTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class StatusTextField: NibTextField {
    
    // MARK: - Enum
    
    public enum ControlStatus: Int {
        case normal = 0
        case editing = 1
        case success = 2
        case warning = 3
        case error = 4
    }
    
    // MARK: - Variables
    
    /// Leave as nil to have placeholder animate into title when text entered in field.
    @IBInspectable open var title: String? {
        get {
            return statusTextFieldNibView?.titleLabel?.text
        }
        set {
            statusTextFieldNibView?.titleLabel?.text = newValue
        }
    }
    
    open var status: ControlStatus = .normal { didSet { setNeedsUpdateView() }}
    
    // MARK: - IBInspectable mapping to contentView Nib
    
    @IBInspectable open var message: String? {
        get {
            return statusTextFieldNibView?.messageLabel?.text
        }
        set {
            statusTextFieldNibView?.messageLabel?.text = newValue
        }
    }
    
    // MARK: - IBInspectable mapping to variables
    
    @IBInspectable open var status_: Int {
        get {
            return status.rawValue
        }
        set {
            status = ControlStatus(rawValue: newValue) ?? .normal
        }
    }
    
    // MARK: - Computed variables
    
    open var messageColor: UIColor {
        return status.color
    }
    
    open var borderStatus: ControlStatus {
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
    
    open override func commonInit() {
        super.commonInit()
        statusTextFieldNibView?.titleLabel?.text = nil
        message = nil
        status = .normal
        super.delegate = self
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Set borderStyle to none since we're using our own borderView.
        borderStyle = .none
    }
    
    // MARK: - updateView
    
    open override func updateView() {
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
    
    open override var placeholder: String? {
        get {
            return isPlaceholderAtTitle && title == nil ? nil : super.placeholder
        }
        set {
            super.placeholder = newValue
        }
    }
    
}

fileprivate extension StatusTextField.ControlStatus {
    
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
    
    open override var delegate: UITextFieldDelegate? {
        get {
            return externalDelegate
        }
        set {
            externalDelegate = newValue
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setNeedsUpdateView()
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        setNeedsUpdateView()
        externalDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let should = externalDelegate?.textField?(textField,
                                                  shouldChangeCharactersIn: range,
                                                  replacementString: string)
            ?? true
        if should {
            setNeedsUpdateView()
        }
        return should
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let should = externalDelegate?.textFieldShouldReturn?(textField) ?? true
        if should {
            resignFirstResponder()
        }
        return should
    }
    
}
