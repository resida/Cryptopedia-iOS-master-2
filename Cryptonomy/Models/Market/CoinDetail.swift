//
//  CoinDetail.swift
//  Cryptonomy
//
//

import Foundation

struct CoinDetail: Codable {
    let response: String
    let type: Int
    let aggregated: Bool
    let data: [Detail]
    let timeto, timefrom: Int
    let firstvalueinarray: Bool
    let conversiontype: ConversionType
}

struct ConversionType: Codable {
    let type, conversionsymbol: String
}

struct Detail: Codable {
    let time: Int
    let close, high, low, open: Double
    let volumefrom, volumeto: Double
}
