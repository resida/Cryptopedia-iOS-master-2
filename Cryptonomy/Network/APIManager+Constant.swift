//
//  APIManager+Constant.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import Foundation

typealias Success = (_ result: AnyObject) -> ()
typealias Failure = (_ errorMessage:String) -> ()

public class APIConstants {
    static let baseURLPro           =   "https://pro-api.coinmarketcap.com/v1/cryptocurrency/"
    static let baseUrl              =   "https://api.coinmarketcap.com/v2"
    static let baseUrlCryptoCompare =   "https://min-api.cryptocompare.com/data"
    static let baseCryptoCompUrl    =   "https://www.cryptocompare.com/api/data/"
}

enum APIEndPoints : String {
    case allTickersPro              = "listings/latest"
    case allTickers                 = "ticker/?sort=rank&structure=array&limit=100"
    case allCoinList                = "all/coinlist"
    case priceMultiFull             = "pricemultifull"
    case coinListDetailMinute       = "histominute"
    case coinListDetailHour         = "histohour"
    case coinListDetailDay          = "histoday"
    case coinNews                   = "v2/news/?lang=EN"
    
    case homeHeaderTickers          = "ticker/?sort=rank&structure=array&limit=2"
    case portfolioAllTickers        = "ticker/?sort=rank&structure=array"
    
    case coinSnapshotById           = "coinsnapshotfullbyid"
}

// API Result enum
enum APIResult : NSInteger {
    case APISuccess = 0, APIFail, APIError
}
