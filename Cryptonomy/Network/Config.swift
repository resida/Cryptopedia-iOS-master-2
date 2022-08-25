//
//  Config.swift
//  Cryptonomy
//
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let appCoinList      = DefaultsKey<[Coin]?>("appCoinList")
    static let arrFavorites     = DefaultsKey<[Datum]?>("arrFavorites")
    static let arrPortfolios    = DefaultsKey<[Trade]?>("arrPortfolios")
    static let currentCurrency  = DefaultsKey<String?>("currentCurrency")
    static let pushNotification = DefaultsKey<Bool?>("pushNotification")
}

struct Global {
    static let CoinMarketCapAPIKey      =   "b3f91bce-eee4-4427-87e9-6f6950c294da"
    static let OneSignalAppID           =   "517b7092-448c-4c00-ac4f-fb100a8b9e28"
    static let appName                  =   Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let corporateEducationURL    =   "http://cryptopediaapp.com/corporate"
    
    static let aboutUsURL               =   "http://cryptopediaapp.com/aboutapp"
    static let joinOurCommunityURL      =   "http://cryptopediaapp.com/community"
    static let supportURL               =   "http://cryptopediaapp.com/supportapp"
    static let contactURL               =   "http://cryptopediaapp.com/contactapp"
    static let blockChainURL            =   "http://cryptopediaapp.com/renaissancelabs"
    static let termsConditionURL        =   "http://cryptopediaapp.com/terms"
}
