//
//  Constants.swift
//  Cryptonomy
//
//

import Foundation
import UIKit
import SwiftyUserDefaults

struct Message {
    static let msg_InternetNotActive        = "Internet Connection appears to be offline. Please try again later."
    static let msg_DefaultError             = "Something went wrong. Please try again later"
}

extension UIColor {
    static var c_Blue : UIColor { return UIColor(hex: 0x135BF0) }
    static var c_Positive : UIColor { return UIColor.red }
    static var c_Negative : UIColor { return UIColor(hex: 0x3d9758) }
    static var c_Red : UIColor { return UIColor.red }
    static var c_Green : UIColor { return UIColor(hex: 0x3d9758) }
    static var c_CommonDarkColor : UIColor { return UIColor(hex: 0x172129) }
    static var c_CommonLightColor : UIColor { return UIColor(hex: 0xA2ACB9) }
    static var c_ChartTypeDefaultColor : UIColor { return UIColor(hex: 0x636F7E) }
    static var c_ChartTypeSelectedColor : UIColor { return UIColor(hex: 0x34CAAE) }
    static var c_PageMenuSelectedColor : UIColor { return UIColor(hex: 0x135BF0) }
    static var c_PageMenuDefaultColor : UIColor { return UIColor(hex: 0x2f2f31) }
}

extension UIFont {
    static func circularMedium(_ size: CGFloat) -> UIFont { return UIFont(name: "CircularStd-Medium", size: size)! }
    static func circularBook(_ size: CGFloat) -> UIFont { return UIFont(name: "CircularStd-Book", size: size)! }
}

extension Notification.Name {
    static let newsNotification = Notification.Name(rawValue: "newsNotification")
}

extension String {
    func formatNumber() -> String{
        let suffix = ["", "K", "M", "B", "T", "P", "E"]
        
        let numFormatter = NumberFormatter()
        let number = numFormatter.number(from: self)
        
        var index = 0
        var value = number as! Double
        while((value / 1000) >= 1){
            value = value / 1000
            index += 1
        }
        return String(format: "$%.1f%@", value, suffix[index])
    }
}

extension Int {
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber (value:value))!
    }
}

extension String {
    func price() -> String {
        let formatter = NumberFormatter()
        let number = formatter.number(from: self)
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: number!)!
    }
}

extension Double {
    func priceFromDouble() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Defaults[.currentCurrency]
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            return formattedTipAmount
        }
        
        return "-"
    }
    
    func priceFromDoubleUSD() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            return formattedTipAmount
        }
        
        return "-"
    }
    
    func toString() -> String {
        return String(format:"%.2f", self) 
    }
    
    func formatNumber() -> String {
        let suffix = ["", "K", "M", "B", "T", "P", "E"]
        let number = self as NSNumber
        
        var index = 0
        var value = number as! Double
        while((value / 1000) >= 1){
            value = value / 1000
            index += 1
        }
        return String(format: "$%.1f%@", value, suffix[index])
    }
    
    func formatNumberCurrency() -> String {
        let suffix = ["", "K", "M", "B", "T", "P", "E"]
        let number = self as NSNumber
        
        var index = 0
        var value = number as! Double
        while((value / 1000) >= 1){
            value = value / 1000
            index += 1
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Defaults[.currentCurrency]
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        
        var stringValue = ""
        if let formattedTipAmount = formatter.string(from: value as NSNumber) {
            stringValue = formattedTipAmount
        }
        
        return String(format: "%@%@", stringValue, suffix[index])
    }
    func formatNumberCurrencyUSD() -> String {
        let suffix = ["", "K", "M", "B", "T", "P", "E"]
        let number = self as NSNumber
        
        var index = 0
        var value = number as! Double
        while((value / 1000) >= 1){
            value = value / 1000
            index += 1
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        
        var stringValue = ""
        if let formattedTipAmount = formatter.string(from: value as NSNumber) {
            stringValue = formattedTipAmount
        }
        
        return String(format: "%@%@", stringValue, suffix[index])
    }
}

extension Date {
    func timeAgoSinceDate(numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: self, to: latest, options: NSCalendar.Options())

        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }

    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds"
        } else {
            return "a moment ago"
        }
        
    }
}

