//
//  CoinInfo.swift
//  Cryptonomy
//
//

import Foundation
import FirebaseDatabase

struct CoinInfo {
    var key: String?
    var value: String?
    var object: [String: String]
    
    init(key: String, value: String? = nil, object: [String: String]? = [:]) {
        self.key = key
        self.value = value
        self.object = object!
    }
}

struct CoinInfoResponse {
    var arrCoinInfo: [CoinInfo] = []
    var arrNetworks: [Network] = []
    var arrRedFlags: [String] = []
    
    init(withSnapshot data: DataSnapshot) {
        if let json = data.value as? [String: AnyObject] {
            if let about = json["about"] as? String, about != "" { self.arrCoinInfo.append(CoinInfo(key: "about", value: about)) }
            if let paperUrl = json["paperUrl"] as? String, paperUrl != "" { self.arrCoinInfo.append(CoinInfo(key: "paperUrl", value: paperUrl)) }
            if let creator = json["creator"] as? String, creator != "" { self.arrCoinInfo.append(CoinInfo(key: "creator", value: creator)) }
            if let dateCreate = json["date_created"] as? String, dateCreate != "" { self.arrCoinInfo.append(CoinInfo(key: "date_created", value: dateCreate)) }
            if let website = json["website"] as? [String: String], let url = website["url"], url != ""  {
                self.arrCoinInfo.append(CoinInfo(key: "website", value: nil, object: website))
            }
            if let method = json["consensus_method"] as? String, method != "" { self.arrCoinInfo.append(CoinInfo(key: "consensus_method", value: method)) }
            if let algo = json["hashing_algorithm"] as? String, algo != "" { self.arrCoinInfo.append(CoinInfo(key: "hashing_algorithm", value: algo)) }
            if let explorer = json["explorer"] as? [String: String], let url = explorer["url"], url != ""  {
                self.arrCoinInfo.append(CoinInfo(key: "explorer", value: nil, object: explorer))
            }
            if let moreInfo = json["more_info"] as? [String: String], let url = moreInfo["url"], url != ""  {
                self.arrCoinInfo.append(CoinInfo(key: "more_info", value: nil, object: moreInfo))
            }
            if let tmpJson = json["networks"] as? [String: AnyObject] {
                for item in tmpJson.keys {
                    if let value = tmpJson[item] as? String, value != "" { self.arrNetworks.append(Network(key: item, value: value)) }
                }
            }
            if let redFlags = json["redflags"] as? [String] {
                self.arrRedFlags = redFlags
            }
        }
    }
}
