//
//  Common.swift
//  Cryptonomy
//
//

import Foundation
import UIKit
import SwiftyUserDefaults
import NVActivityIndicatorView
import SwiftWebVC

extension NSMutableAttributedString {
    func changeFont(text:String, font:UIFont, fontColor:UIColor) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: fontColor]
        let attributedText = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        return attributedText
    }
    
    func changeTextWithSpacing(lineSpacing: CGFloat = 0.0,  text:String, font:UIFont, fontColor:UIColor) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: fontColor]
        
        let attributedText = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        return attributedText
    }
    
}

class Common {
    class func showAlert(_ title: String, _ strMessage:String, _ withTarget:UIViewController){
        let alert = UIAlertController(title: title, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alert.addAction(okAction)
        withTarget.present(alert, animated: true, completion: nil)
    }
    
    class func getCurrentTimeFromTimeStamp(_ aTimestamp: Double,_ withFormat: String) -> String{
        
        let date = Date(timeIntervalSince1970: aTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
//        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
//        dateFormatter.dateStyle = DateFormatter.Style.none //Set date style
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        let localDate = dateFormatter.string(from: date)
        return localDate
    }

    static func getCurrentPriceData(_ currentTicker: Datum) -> Usd? {
        var usd = currentTicker.quote.usd
        let currency = Defaults[.currentCurrency]
        if currency == "USD" {
            usd = currentTicker.quote.usd
        } else if currency == "EUR" {
            usd = currentTicker.quote.eur
        } else if currency == "GBP" {
            usd = currentTicker.quote.gbp
        } else if currency == "JPY" {
            usd = currentTicker.quote.jpy
        } else if currency == "AUD" {
            usd = currentTicker.quote.aud
        } else if currency == "CAD" {
            usd = currentTicker.quote.cad
        } else if currency == "BRL" {
            usd = currentTicker.quote.brl
        }
        return usd
    }
    
    static func showLoading() {
        let activityData = ActivityData(size: CGSize(width: 40, height: 40), type: NVActivityIndicatorType.ballPulse, color: UIColor.white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    static func hideLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
}

extension UIViewController {
    func openWebViewInApp(at url:String, title: String = "News") {
        let webVC = SwiftModalWebVC(urlString: url)
        webVC.title = title
        self.navigationController?.present(webVC, animated: true, completion: nil)
    }
}
