//
//  IcoEntity.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - IcoStatus
enum IcoStatus: String {
    case none
    case active = "active"
    case ongoing = "ongoing"
    case upcoming = "upcoming"
    case ended = "ended"
}

// MARK: - IcoSummaryList
struct IcoSummaryList: Mappable {
    var icos: Int = 0
    var pages: Int = 0
    var currentPage: Int = 0
    var results: Array<IcoSummary>? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.icos           <- map["icos"]
        self.pages          <- map["pages"]
        self.currentPage    <- map["currentPage"]
        self.results        <- map["results"]
    }
}

// MARK: - IcoSummary
struct IcoSummary: Mappable {
    var id: Int = 0
    var name: String? = nil
    var url: String? = nil
    var logo: String? = nil
    var desc: String? = nil
    var rating: Float = 0
    var premium: Int = 0
    var raised: Int = 0
    var dates: IcoDates? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.url        <- map["url"]
        self.logo       <- map["logo"]
        self.desc       <- map["desc"]
        self.rating     <- map["rating"]
        self.premium    <- map["premium"]
        self.raised     <- map["raised"]
        self.dates      <- map["dates"]
    }
}

// MARK: - IcoDates
struct IcoDates: Mappable {
    var preIcoStart: String? = nil
    var preIcoEnd: String? = nil
    var icoStart: String? = nil
    var icoEnd: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.preIcoStart    <- map["preIcoStart"]
        self.preIcoEnd      <- map["preIcoEnd"]
        self.icoStart       <- map["icoStart"]
        self.icoEnd         <- map["icoEnd"]
    }
}
