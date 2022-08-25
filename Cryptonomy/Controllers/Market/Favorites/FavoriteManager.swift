//
//  FavoriteManager.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults

public class FavoriteManager {
    var arrFavorites : [Datum]! = []
    
    static let shared : FavoriteManager = {
        let instance = FavoriteManager()
        if let arr = Defaults[.arrFavorites] {
            instance.arrFavorites = arr
        } else {
            instance.arrFavorites = []
        }
        return instance
    }()
    
    func refreshFavoritesData() {
        for (index, _) in self.arrFavorites.enumerated() { self.arrFavorites[index].isListUpdated = false }
        Defaults[.arrFavorites] = self.arrFavorites
    }
    
    func getFavoriteData(completion: @escaping (()->())) {
        let mList = MarketList.shared
        if let totalArrData = mList.listResponse?.data {
            var newArray : [Datum] = []
            let favoriteData = FavoriteManager.shared.arrFavorites
            for item in favoriteData!.enumerated() {
                let filteredItem = totalArrData.filter{ $0.symbol == item.element.symbol }.first
                newArray.append(filteredItem!)
            }
            self.updateFavoriteData(newArray)
            completion()
        }
    }
    
    func updateFavoriteData(_ newArray: [Datum]) {
        self.arrFavorites.removeAll()
        Defaults[.arrFavorites] = newArray
        self.arrFavorites = newArray        
    }
}
