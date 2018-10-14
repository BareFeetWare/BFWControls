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
    
    private static var indentPosition = 0
    private static let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        return dateFormatter
    }()
    
    /// Write message to a log file. Useful for IBDesignable debugging, since the normal print() doesn't log to the Xcode console.
    public static func write(_ message: String,
                             indent: Int = 0,
                             toFilePath filePath: String = "/tmp/IBDesignable.log")
    {
        #if TARGET_INTERFACE_BUILDER
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
        }
        let fileHandle = FileHandle(forWritingAtPath: filePath)!
        fileHandle.seekToEndOfFile()
        if indent < 0 {
            indentPosition += indent
        }
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let indentString = String(repeating: "  ", count: indentPosition)
        if indent > 0 {
            indentPosition += indent
        }
        let data = "\(dateString) \(indentString) \(message)\n"
            .data(using: String.Encoding.utf8, allowLossyConversion: true)!
        fileHandle.write(data)
        #endif
    }
    
}
