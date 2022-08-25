//
//  DateTimeUtil.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 24..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation

// MARK: - DateTimeUtil
class DateTimeUtil {
    class func localDateTime(date: Date? = Date()) -> Date {
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds = TimeInterval(timeZone.secondsFromGMT())
        return Date(timeInterval: seconds, since: date!)
    }
    
    // MARK: Date with String
    class func date(originStr: String, targetFormat: String, locale: Locale?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = targetFormat
        if nil != locale {
            formatter.locale = locale!
        }
        return formatter.date(from: originStr)
    }
    
    class func date(originStr: String, targetStyle: DateFormatter.Style, locale: Locale?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = targetStyle
        if nil != locale {
            formatter.locale = locale!
        }
        return formatter.date(from: originStr)
    }
    
    // MARK: String with Date
    class func string(originDate: Date, targetFormat: String, locale: Locale?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = targetFormat
        if nil != locale {
            formatter.locale = locale!
        }
        return formatter.string(from: originDate)
    }
    
    class func string(originDate: Date, targetStyle: DateFormatter.Style, locale: Locale?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = targetStyle
        if nil != locale {
            formatter.locale = locale!
        }
        return formatter.string(from: originDate)
    }
    
    // MARK: String with String
    class func string(originStr: String, originFormat: String, targetFormat: String, locale: Locale?) -> String? {
        var targetStr: String? = nil
        let formatter = DateFormatter()
        formatter.dateFormat = originFormat
        if nil != locale {
            formatter.locale = locale!
        }
        if let date = formatter.date(from: originStr) {
            formatter.dateFormat = targetFormat
            targetStr = formatter.string(from: date)
        }
        return targetStr
    }
    
    class func string(originStr: String, originStyle: DateFormatter.Style, targetStyle: DateFormatter.Style, locale: Locale?) -> String? {
        var targetStr: String? = nil
        let formatter = DateFormatter()
        formatter.dateStyle = originStyle
        if nil != locale {
            formatter.locale = locale!
        }
        if let date = formatter.date(from: originStr) {
            formatter.dateStyle = targetStyle
            targetStr = formatter.string(from: date)
        }
        return targetStr
    }
}

// MARK: - Custom
extension DateTimeUtil {
    class func changeIcoDateFormat(dateStr: String?) -> String? {
        var targetDateStr: String? = nil
        if nil != dateStr {
            targetDateStr = DateTimeUtil.string(
                originStr: dateStr!,
                originFormat: "yyyy-MM-dd HH:mm:ss",
                targetFormat: "yyyy-MM-dd HH:mm",
                locale: nil
            )
        }
        return targetDateStr
    }
    
    class func changeNewsPubDateFormat(dateStr: String?) -> String? {
        var pubDate: String? = nil
        if let date = dateStr {
            pubDate = DateTimeUtil.string(
                originStr: date,
                originFormat: "E, d MMM yyyy HH:mm:ss Z",
                targetFormat: "yyyy-MM-dd HH:mm",
                locale: Locale(identifier: "en_US_POSIX")
            )
        }
        return pubDate
    }
}
