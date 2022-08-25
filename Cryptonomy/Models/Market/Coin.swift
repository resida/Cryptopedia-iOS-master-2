//
//  Coin.swift
//  Cryptonomy
//

import Foundation
import SwiftyUserDefaults

let sharedData = CoinListData.shared

public class CoinListData {
    var arrCoinData : [Coin]! = []
    static let shared : CoinListData = {
        let instance = CoinListData()
        if let arr = Defaults[.appCoinList] {
            instance.arrCoinData = arr
        } else {
            instance.arrCoinData = nil
        }
        return instance
    }()
    
    func updateLocalData(_ data: [Coin]) {
        Defaults[.appCoinList] = data
        
        if self.arrCoinData != nil, self.arrCoinData.count > 0 {
            self.arrCoinData.removeAll()
        }
        self.arrCoinData = data
    }
}

struct Coin: Codable {
    let key: String
    let coinData: CoinData
    
    init(key: String, coinData: CoinData) {
        self.key = key
        self.coinData = coinData
    }
}

struct CoinListResponse: Codable {
    let response, message, baseImageURL, baseLinkURL: String
    let data: [String: CoinData]
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message = "Message"
        case baseImageURL = "BaseImageUrl"
        case baseLinkURL = "BaseLinkUrl"
        case data = "Data"
    }
}

struct CoinData: Codable {
    let id, url: String
    let imageURL: String?
    let name, symbol, coinName, fullName: String
    let algorithm: String
    let fullyPremined, totalCoinSupply: String
    let sortOrder: String
    let sponsored : Bool
    let isTrading: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case url = "Url"
        case imageURL = "ImageUrl"
        case name = "Name"
        case symbol = "Symbol"
        case coinName = "CoinName"
        case fullName = "FullName"
        case algorithm = "Algorithm"
        case fullyPremined = "FullyPremined"
        case totalCoinSupply = "TotalCoinSupply"
        case sortOrder = "SortOrder"
        case sponsored = "Sponsored"
        case isTrading = "IsTrading"
    }
}

struct DefaultWatchlist: Codable {
    let coinIs, sponsored: String
    
    enum CodingKeys: String, CodingKey {
        case coinIs = "CoinIs"
        case sponsored = "Sponsored"
    }
}

struct SponosoredNew: Codable {
    let id: Int
    let guid: String
    let publishedOn: Int
    let imageurl, title, url, source: String
    let body, tags, categories, lang: String
    let sourceInfo: SourceInfo
    
    enum CodingKeys: String, CodingKey {
        case id, guid
        case publishedOn = "published_on"
        case imageurl, title, url, source, body, tags, categories, lang
        case sourceInfo = "source_info"
    }
}

struct SourceInfo: Codable {
    
}
