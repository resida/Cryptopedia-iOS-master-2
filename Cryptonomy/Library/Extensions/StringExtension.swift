//
//  String.swift
//  Cryptonomy
//
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        _ = subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
        return resultString
    }
    func trim() -> String {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }
    
    func documentDirectory() -> String {
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        documentsPath = documentsPath.stringByAppendingPathComponent(path: self)
        return documentsPath
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func createFolder() {
        let path = self.documentDirectory()
        if FileManager.default.fileExists(atPath: path) == false {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    func isPositive() -> Bool {
        return self.floatValue > 0
    }
    
    var html2AttributedString : NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options:[.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

