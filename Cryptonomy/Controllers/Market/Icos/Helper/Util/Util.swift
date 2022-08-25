//
//  Util.swift
//  ICOCO
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import Foundation

func prLog(_ message: Any? = "", showTime: Bool = false, file: String = #file, funcName: String = #function, line: Int = #line) {
    let fileName: String = (file as NSString).lastPathComponent
    var fullMessage = "\(fileName): \(funcName): \(line): \(String(describing: message))"
    
    if true == showTime {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd KK:mm:ss.SSS"
        let timeStr = dateFormatter.string(from: Date())
        fullMessage = "\(timeStr): " + fullMessage
    }
    
    print(fullMessage)
}

// MARK: - Base
class Util {
}
