//
//  PortfolioManager.swift
//  Cryptonomy
//

import UIKit
import SwiftyUserDefaults

public class PortfolioManager {
    var arrPortfolios : [Trade]! = []
    var timestamp: TimeInterval?
    var listResponse: ListResponse!
    
    static let shared: PortfolioManager = {
        let instance = PortfolioManager()
        if let arr = Defaults[.arrPortfolios] {
            instance.arrPortfolios = arr
        } else {
            instance.arrPortfolios = []
        }
        return instance
    }()
    
    func appendNewTrade(trade: Trade) {
        self.arrPortfolios.append(trade)
        Defaults[.arrPortfolios] = self.arrPortfolios
    }
    
    func shouldCallPortfolioWebAPITimeStamp() -> Bool {
        guard let timeStamp = self.timestamp else { return true }
        
        let currentTimeStamp = Date().timeIntervalSince1970
        let diff = Int(currentTimeStamp - timeStamp)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        
        return minutes >= 1
    }
}
