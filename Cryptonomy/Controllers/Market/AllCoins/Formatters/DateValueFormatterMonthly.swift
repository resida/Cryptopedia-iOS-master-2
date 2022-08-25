//
//  DateValueFormatter.swift
//  Cryptonomy
//
//

import UIKit
import Foundation
import Charts

public class DateValueFormatterMonthly: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        
        dateFormatter.dateFormat = "M/d"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value)).lowercased()
    }
}
