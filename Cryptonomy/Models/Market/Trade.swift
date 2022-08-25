//
//  Trade.swift
//  Coinr
//
//  Created by Jimi Duiveman on 23-01-18.
//  Copyright © 2018 Jimi Duiveman. All rights reserved.
//

import Foundation

class Trade: Codable {
    let key: String
    let coinSymbol: String
    let coinPriceBought: String
    let totalPrice: String
    let amountBought: String
    let timeStamp: String
    let type: String
    
    init(coinSymbol: String, coinPriceBought: String, totalPrice: String, amountBought: String, timeStamp: String, type: String, key: String = "") {
        self.key = key
        self.coinSymbol = coinSymbol
        self.coinPriceBought = coinPriceBought
        self.totalPrice = totalPrice
        self.amountBought = amountBought
        self.timeStamp = timeStamp
        self.type = type
    }
}
