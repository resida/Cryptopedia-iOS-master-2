//
//  IcoProfileEntity.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 25..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - IcoProfile
struct IcoProfile: Mappable {
    var id: Int = 0
    var name: String? = nil
    var rating: Float = 0
    var ratingTeam: Float = 0
    var ratingVision: Float = 0
    var ratingProduct: Float = 0
    var ratingProfile: Float = 0
    var url: String? = nil
    var tagline: String? = nil
    var intro: String? = nil
    var about: String? = nil
    var logo: String? = nil
    var country: String? = nil
    var notification: String? = nil
    var registration: String? = nil
    var restrictions: Array<IcoRestriction>? = nil
    var milestones: Array<IcoMilestone>? = nil
    var teamIntro: String? = nil
    var links: IcoLinks? = nil
    var finance: IcoFinance? = nil
    var dates: IcoDates? = nil
    var team: Array<IcoTeam>? = nil
    var ratings: Array<IcoRating>? = nil
    var categories: Array<IcoCategory>? = nil
    var exchanges: Array<IcoExchange>? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.id             <- map["id"]
        self.name           <- map["name"]
        self.rating         <- map["rating"]
        self.ratingTeam     <- map["ratingTeam"]
        self.ratingVision   <- map["ratingVision"]
        self.ratingProduct  <- map["ratingProduct"]
        self.ratingProfile  <- map["ratingProfile"]
        self.url            <- map["url"]
        self.tagline        <- map["tagline"]
        self.intro          <- map["intro"]
        self.about          <- map["about"]
        self.logo           <- map["logo"]
        self.country        <- map["country"]
        self.notification   <- map["notification"]
        self.registration   <- map["registration"]
        self.restrictions   <- map["restrictions"]
        self.milestones     <- map["milestones"]
        self.teamIntro      <- map["teamIntro"]
        self.links          <- map["links"]
        self.finance        <- map["finance"]
        self.dates          <- map["dates"]
        self.team           <- map["team"]
        self.ratings        <- map["ratings"]
        self.categories     <- map["categories"]
        self.exchanges      <- map["exchanges"]
    }
}

struct IcoRestriction: Mappable {
    var country: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.country    <- map["country"]
    }
}

struct IcoMilestone: Mappable {
    var title: String? = nil
    var content: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.title      <- map["title"]
        self.content    <- map["content"]
    }
}

struct IcoLinks: Mappable {
    var twitter: String? = nil
    var slack: String? = nil
    var telegram: String? = nil
    var facebook: String? = nil
    var medium: String? = nil
    var bitcointalk: String? = nil
    var github: String? = nil
    var reddit: String? = nil
    var discord: String? = nil
    var video: String?  = nil
    var www: String? = nil
    var whitepaper: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.twitter        <- map["twitter"]
        self.slack          <- map["slack"]
        self.telegram       <- map["telegram"]
        self.facebook       <- map["facebook"]
        self.medium         <- map["medium"]
        self.bitcointalk    <- map["bitcointalk"]
        self.github         <- map["github"]
        self.reddit         <- map["reddit"]
        self.discord        <- map["discord"]
        self.video          <- map["video"]
        self.www            <- map["www"]
        self.whitepaper     <- map["whitepaper"]
        
        
    }
}

struct IcoFinance: Mappable {
    var token: String? = nil
    var price: String? = nil
    var bonus: Bool = false
    var tokens: Int = 0
    var tokentype: String? = nil
    var hardcap: String? = nil
    var softcap: String? = nil
    var raised: Int = 0
    var platform: String? = nil
    var distributed: String? = nil
    var minimum: String? = nil
    var accepting: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.token          <- map["token"]
        self.price          <- map["price"]
        self.bonus          <- map["bonus"]
        self.tokens         <- map["tokens"]
        self.tokentype      <- map["tokentype"]
        self.hardcap        <- map["hardcap"]
        self.softcap        <- map["softcap"]
        self.raised         <- map["raised"]
        self.platform       <- map["platform"]
        self.distributed    <- map["distributed"]
        self.minimum        <- map["minimum"]
        self.accepting      <- map["accepting"]
    }
}

struct IcoTeam: Mappable {
    var name: String? = nil
    var title: String? = nil
    var socials: Array<IcoSocial>? = nil
    var group: String? = nil
    var photo: String? = nil
    var iss: Float? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.name       <- map["name"]
        self.title      <- map["title"]
        self.socials    <- map["socials"]
        self.group      <- map["group"]
        self.photo      <- map["photo"]
        self.iss        <- map["iss"]
    }
}

struct IcoSocial: Mappable {
    var site: String? = nil
    var url: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.site   <- map["site"]
        self.url    <- map["url"]
    }
}

struct IcoRating: Mappable {
    var date: String? = nil
    var name: String? = nil
    var title: String? = nil
    var photo: String? = nil
    var team: Int = 0
    var vision: Int = 0
    var product: Int = 0
    var profile: Int = 0
    var review: String? = nil
    var weight: String? = nil
    var agree: Int = 0
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.date       <- map["date"]
        self.name       <- map["name"]
        self.title      <- map["title"]
        self.photo      <- map["photo"]
        self.team       <- map["team"]
        self.vision     <- map["vision"]
        self.product    <- map["product"]
        self.profile    <- map["profile"]
        self.review     <- map["review"]
        self.weight     <- map["weight"]
        self.agree      <- map["agree"]
    }
}

struct IcoCategory: Mappable {
    var id: Int = 0
    var name: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.id     <- map["id"]
        self.name   <- map["name"]
    }
}

struct IcoExchange: Mappable {
    var id: Int = 0
    var name: String? = nil
    var logo: String? = nil
    var price: Float = 0
    var currency: String? = nil
    var roi: String? = nil
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.logo       <- map["logo"]
        self.price      <- map["price"]
        self.currency   <- map["currency"]
        self.roi        <- map["roi"]
    }
}

