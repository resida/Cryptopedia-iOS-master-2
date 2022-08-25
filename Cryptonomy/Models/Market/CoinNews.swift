//
//  CoinNews.swift
//  Cryptonomy
//
//  Created by MAC001 on 26/06/18.
//  Copyright © 2018 Vivek Aghera. All rights reserved.
//

import Foundation

struct DatumCoinNews: Codable {
    let id, guid: String?
    let publishedOn: Int
    let title, url, source: String?
    let body, tags, categories, upvotes: String?
    let downvotes: String?
    let lang: Lang
    let sourceInfo: DatumSourceInfo
    let imageurl: String?
}

enum Lang: String, Codable {
    case en = "EN"
}

struct DatumSourceInfo: Codable {
    let name: String?
    let lang: Lang?
    let img: String?
}
