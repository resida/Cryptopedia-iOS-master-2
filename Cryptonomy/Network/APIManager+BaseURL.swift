//
//  APIManager+BaseURL.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension APIManager {
    
    static func marketListProUrl(endpoint: APIEndPoints) -> String {
        let url = APIConstants.baseURLPro + endpoint.rawValue
        return url
    }
    
    static func makeAppUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrl)/\(endpoint.rawValue)"
        return url
    }

    static  func makeAppUrlCoinMarketCap(endpoint: APIEndPoints, start: Int) -> String {
        let url = "\(APIConstants.baseUrl)/\(endpoint.rawValue)&start=\(start)&convert=\(Defaults[.currentCurrency] ?? "USD")"
        return url
    }
    
    static func makeCryptoBaseUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrlCryptoCompare)/\(endpoint.rawValue)"
        return url
    }
    
    static func makeCryptoDetailUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrlCryptoCompare)/\(endpoint.rawValue)"
        return url
    }
    
    static func makeCryptoDetailHourUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrlCryptoCompare)/\(endpoint.rawValue)"
        return url
    }
    
    static func makeCryptoDetailDayUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrlCryptoCompare)/\(endpoint.rawValue)"
        return url
    }
    
    static func makeCryptoBaseUrlCoinNews(endpoint: APIEndPoints, symbol: String) -> String {
        let url = "\(APIConstants.baseUrlCryptoCompare)/\(endpoint.rawValue)?categories=\(symbol)"
        return url
    }
    
    static func makePortfolioTickerUrl(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseUrl)/\(endpoint.rawValue)"
        return url
    }
    
    static func makeCryptoCompareCoinSnapshot(endpoint: APIEndPoints) -> String {
        let url = "\(APIConstants.baseCryptoCompUrl)"+"\(endpoint.rawValue)"
        return url
    }
}
