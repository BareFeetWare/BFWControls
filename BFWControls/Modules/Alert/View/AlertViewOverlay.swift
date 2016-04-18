//
//  AlertViewOverlay.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 19/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

@IBDesignable class AlertViewOverlay: NibView {

    // MARK: - IBOutlets
    
    @IBOutlet var alertView: AlertView!
    
    @IBOutlet weak var delegate: NSObject? {
        get {
            return alertView.delegate
        }
        set {
            alertView.delegate = newValue
        }
    }

    // MARK: - Variables mapping to AlertView variables
    
    @IBInspectable var title: String? {
        get {
            return alertView.title
        }
        set {
            alertView.title = newValue
        }
    }
    
    @IBInspectable var message: String? {
        get {
            return alertView.message
        }
        set {
            alertView.message = newValue
        }
    }
    
    @IBInspectable var hasCancel: Bool {
        get {
            return alertView.hasCancel
        }
        set {
            alertView.hasCancel = newValue
        }
    }
    
    @IBInspectable var button0Title: String? {
        get {
            return alertView.button0Title
        }
        set {
            alertView.button0Title = newValue
        }
    }
    
    @IBInspectable var button1Title: String? {
        get {
            return alertView.button1Title
        }
        set {
            alertView.button1Title = newValue
        }
    }
    
    @IBInspectable var button2Title: String? {
        get {
            return alertView.button2Title
        }
        set {
            alertView.button2Title = newValue
        }
    }
    
    @IBInspectable var button3Title: String? {
        get {
            return alertView.button3Title
        }
        set {
            alertView.button3Title = newValue
        }
    }
    
}
