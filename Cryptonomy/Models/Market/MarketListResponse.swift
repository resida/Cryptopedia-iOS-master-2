//
//  CoinList.swift
//  Cryptonomy
//

import Foundation

public class Currency {
    var arrSymbols : [String]! = []
    static let shared : Currency = {
        let instance = Currency()
        instance.arrSymbols = ["USD","EUR","GBP","JPY","AUD","CAD","BRL"]
        return instance
    }()
}

public class MarketList {
    var listResponse: ListResponse?
    var timestamp: TimeInterval?
    
    static let shared: MarketList = {
        let instance = MarketList()
        return instance
    }()
    
    func shouldCallWebAPITimeStamp() -> Bool {
        guard let timeStamp = self.timestamp else {
            return true
        }
        let currentTimeStamp = Date().timeIntervalSince1970
        let diff = Int(currentTimeStamp - timeStamp)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return minutes >= 1
    }
    
    func updateData(_ listResponse: ListResponse) {
        self.listResponse?.data.removeAll()
        self.listResponse = listResponse
        self.timestamp = Date().timeIntervalSince1970
    }
}

struct ListResponse: Codable {
    var status: Status
    var data: [Datum] = []
}

struct Status: Codable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed: Int?
    let creditCount: Int?
}

//MARK :- Coin Market Cap Api

struct MarketListResponse: Codable {
    let data: [Datum]
    let metadata: Metadata
}

struct Datum: Codable, Equatable {
    let id: Int
    let name, symbol, slug: String?
    let cmcRank: Int?
    let maxSupply: Double?
    let quote: Quotes
    let lastUpdated: String?
    var coinImageUrl: String?
    var isListUpdated: Bool?
    
    static func ==(lhs:Datum, rhs:Datum) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

struct Quotes: Codable {
    let usd: Usd?
    let eur: Eur?
    let gbp: Gbp?
    let jpy: Jpy?
    let aud: Aud?
    let cad: Cad?
    let brl: Brl?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case jpy = "JPY"
        case aud = "AUD"
        case cad = "CAD"
        case brl = "BRL"
    }
}

class Usd: Codable {
    var price:Double!
    var volume24H: Double!
    var marketCap: Double!
    var percentChange1H: Double!
    var percentChange24H: Double!
    var percentChange7D: Double!
}

class Eur: Usd { }
class Gbp: Usd { }
class Jpy: Usd { }
class Aud: Usd { }
class Cad: Usd { }
class Brl: Usd { }

struct Metadata: Codable {
    let timestamp: Int
    let numCryptocurrencies: Int?
    let error: String?
}

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

