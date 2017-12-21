//
//  Binding.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/07/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class Binding: NSObject {

    // MARK: - Variables
    
    @IBOutlet var view: UIView? {
        didSet {
            updateBinding()
        }
    }
    
    @IBInspectable var plist: String? {
        didSet {
            updateBinding()
        }
    }
    
    @IBInspectable var viewKeyPath: String? = "text" {
        didSet {
            updateBinding()
        }
    }

    @IBInspectable var variable: String? {
        didSet {
            updateBinding()
        }
    }

    private static var rootBindingDict = [String: [String: AnyObject]]()
    
    fileprivate var bindingDict: [String: AnyObject]? {
        get {
            var bindingDict: [String: AnyObject]?
            if let plist = plist {
                if let dict = Binding.rootBindingDict[plist] {
                    bindingDict = dict
                } else {
                    if let path = Bundle.main.path(forResource: plist, ofType: "plist"),
                        let plistDict = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
                    {
                        bindingDict = plistDict
                        Binding.rootBindingDict[plist] = bindingDict
                    }
                }
            }
            return bindingDict
        }
    }

    // MARK: - Functions

    private func updateBinding() {
        if let view = view,
            let keyPath = viewKeyPath,
            let variable = variable,
            let bindingDict = bindingDict,
            let value = bindingDict[variable]
        {
            let string = String(describing: value)
            view.setValue(string, forKeyPath: keyPath)
            if let textField = view as? UITextField,
                viewKeyPath == "text"
            {
                textField.delegate = self
            }
        }
    }
    
}

extension Binding: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var bindingDict = bindingDict, let variable = variable {
            bindingDict[variable] = textField.text as AnyObject?
        }
    }
    
}
