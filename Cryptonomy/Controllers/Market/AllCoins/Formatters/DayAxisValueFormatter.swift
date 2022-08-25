//
//  DayAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    var labels: [Int] = []
    var dateFormatter = DateFormatter()
    
    init(labels: [Int], format: String) {
        super.init()
        
        self.labels = labels
        self.dateFormatter.dateFormat = format
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index < labels.count && index >= 0 {
            return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.labels[index]))).lowercased()
        } else {
            return ""
        }
    }
}
