//
//  IBLog.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 12/10/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import Foundation

open class IBLog {
    
    /// Write message to a log file.Useful for IBDesignable debugging, since the normal print() doesn't log to the Xcode console.
    public static func write(_ message: String,
                             filePath: String = "/tmp/IBDesignable.log")
    {
        #if TARGET_INTERFACE_BUILDER
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
        }
        
        let fileHandle = FileHandle(forWritingAtPath: filePath)!
        fileHandle.seekToEndOfFile()
        
        let date = Date()
        let bundle = Bundle(for: self)
        let applicationName: AnyObject = bundle.object(forInfoDictionaryKey: "CFBundleName") as AnyObject
        let data = "\(date) \(applicationName) \(message)\n"
            .data(using: String.Encoding.utf8, allowLossyConversion: true)!
        fileHandle.write(data)
        #endif
    }
    
}
