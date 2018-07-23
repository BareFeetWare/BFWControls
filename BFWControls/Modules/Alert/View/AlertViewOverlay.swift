//
//  AlertViewOverlay.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 19/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class AlertViewOverlay: NibView {
    
    // MARK: - IBOutlets
    
    @objc open lazy var alertView: AlertView! = {
        return self.subviews.first { subview in
            subview is AlertView
            } as? AlertView
    }()
    
    // MARK: - Variables mapping to AlertView variables
    
    @IBInspectable open var title: String? {
        get {
            return alertView.title
        }
        set {
            alertView.title = newValue
        }
    }
    
    @IBInspectable open var message: String? {
        get {
            return alertView.message
        }
        set {
            alertView.message = newValue
        }
    }
    
    @IBInspectable open var hasCancel: Bool {
        get {
            return alertView.hasCancel
        }
        set {
            alertView.hasCancel = newValue
        }
    }
    
    @IBInspectable open var button0Title: String? {
        get {
            return alertView.button0Title
        }
        set {
            alertView.button0Title = newValue
        }
    }
    
    @IBInspectable open var button1Title: String? {
        get {
            return alertView.button1Title
        }
        set {
            alertView.button1Title = newValue
        }
    }
    
    @IBInspectable open var button2Title: String? {
        get {
            return alertView.button2Title
        }
        set {
            alertView.button2Title = newValue
        }
    }
    
    @IBInspectable open var button3Title: String? {
        get {
            return alertView.button3Title
        }
        set {
            alertView.button3Title = newValue
        }
    }
    
    @IBInspectable open var button4Title: String? {
        get {
            return alertView.button4Title
        }
        set {
            alertView.button4Title = newValue
        }
    }
    
    @IBInspectable open var button5Title: String? {
        get {
            return alertView.button5Title
        }
        set {
            alertView.button5Title = newValue
        }
    }
    
    @IBInspectable open var button6Title: String? {
        get {
            return alertView.button6Title
        }
        set {
            alertView.button6Title = newValue
        }
    }
    
    @IBInspectable open var button7Title: String? {
        get {
            return alertView.button7Title
        }
        set {
            alertView.button7Title = newValue
        }
    }
    
    @IBInspectable open var maxHorizontalButtonTitleCharacterCount: Int {
        get {
            return alertView.maxHorizontalButtonTitleCharacterCount
        }
        set {
            alertView.maxHorizontalButtonTitleCharacterCount = newValue
        }
    }
    
}
