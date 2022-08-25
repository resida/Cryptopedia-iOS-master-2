//
//  StringUtil.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 24..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation

class StringUtil {
    class func removeHtmlTag(html: String?) -> String {
        var htmlStr = html
        htmlStr = htmlStr?.replacingOccurrences(of: "<[/ ]*br[/ ]*>", with: "\n", options: .regularExpression, range: nil)
        htmlStr = htmlStr?.replacingOccurrences(of: "<[^>]+?>", with: "", options: .regularExpression, range: nil)
        htmlStr = htmlStr?.replacingOccurrences(of: "&lt;", with: "<")
        htmlStr = htmlStr?.replacingOccurrences(of: "&gt;", with: ">")
        htmlStr = htmlStr?.replacingOccurrences(of: "&quot;", with: "\"")
        htmlStr = htmlStr?.replacingOccurrences(of: "&apos;", with: "'")
        htmlStr = htmlStr?.replacingOccurrences(of: "&nbsp;", with: " ")
        htmlStr = htmlStr?.replacingOccurrences(of: "&amp;", with: "&")
        return htmlStr ?? ""
    }
}
