//
//  APIManager+Params.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import Foundation

struct Params {
    let fsyms: String?
    let tsyms: String?
    var limit: Int? = 0
    var aggregate: Int? = 0
    
    init(fsyms: String, tsyms: String) {
        self.fsyms = fsyms
        self.tsyms = tsyms
    }

    init(fsyms: String? = nil, tsyms: String? = nil , limit: Int? = 0, aggregate: Int? = 0) {
        self.fsyms = fsyms
        self.tsyms = tsyms
        self.limit = limit
        self.aggregate = aggregate
    }
}

class TickerParams {
    var sort: String = "market_cap"
    var start: String = "1"
    var limit: String = "5000"
    var cryptocurrencyType: String = "all"
    var convert: String = "USD"
}
