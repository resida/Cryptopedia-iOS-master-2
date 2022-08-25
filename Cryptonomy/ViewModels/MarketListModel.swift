//
//  HomeListModel.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults
import PKHUD

class MarketListModel: NSObject {
    typealias didSelectItemAtIndex = ((_ tableView: UITableView, _ indexPath: IndexPath, _ rawList: Datum) -> ())?
    
    var didSelectItem: didSelectItemAtIndex = nil
    var reloadTableViewClosure:(()->())? = nil
    var errorOccured: ((String)->())? = nil
    
    var cellViewModels: [Datum] = []
    
    var arrCoins: [Coin] = []
    
    //MARK: - Init
    
    override init() {
        super.init()
    }
    
    func updateFavoritesLocalData() {
        for (index, item) in FavoriteManager.shared.arrFavorites.enumerated() {
            let cIndex = self.cellViewModels.firstIndex(of: item)
            if cIndex != nil {
                let datum = self.cellViewModels[cIndex!]
                FavoriteManager.shared.arrFavorites[index] = datum
            }
        }
        Defaults[.arrFavorites] = FavoriteManager.shared.arrFavorites
    }
    
    @objc func fetchCoinList(animated: Bool = true) {
        guard let _ = sharedData.arrCoinData else {
            if animated { Common.showLoading() }
            apiMgr.getAllCointListData(success: { result in
                var allData = [Coin]()
                for(key, value) in result {
                    let coin = Coin(key: key, coinData: value)
                    allData.append(coin)
                }
                let sortedCoinList = allData.sorted(by: { Int($0.coinData.sortOrder)! < Int($1.coinData.sortOrder)!})
                sharedData.updateLocalData(sortedCoinList)
                self.fetchCoinMarketCapDataPro(showLoading: animated)
            }, failure: { message in
                if let error = self.errorOccured { error(message) }
                Common.hideLoading()
            })
            return
        }
        self.fetchCoinMarketCapDataPro(showLoading: animated)
    }
    
    func fetchCoinMarketCapDataPro(showLoading: Bool = true) {
        if showLoading { Common.showLoading() }
        let params = TickerParams()
        params.convert = Defaults[.currentCurrency]!
        
        apiMgr.getAllMarketListDataPro(params, success: {
            self.cellViewModels = (MarketList.shared.listResponse?.data)!
            self.updateFavoritesLocalData()
            self.reloadTableViewClosure!()
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
        })
    }
    
    func resetData() {
        self.cellViewModels.removeAll()
    }
    
    func fetchFavoritesData(completion: @escaping (()->())) {
        if MarketList.shared.shouldCallWebAPITimeStamp() {
            self.fetchCoinMarketCapDataPro(showLoading: false)
        } else {
            let mList = MarketList.shared
            if let totalArrData = mList.listResponse?.data {
                var newArray : [Datum] = []
                let favoriteData = FavoriteManager.shared.arrFavorites
                for item in favoriteData!.enumerated() {
                    let filteredItem = totalArrData.filter{ $0.symbol == item.element.symbol }.first
                    newArray.append(filteredItem!)
                }
                FavoriteManager.shared.updateFavoriteData(newArray)
                completion()
            }
        }
    }
}

extension MarketListModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketListCell.identifier) as! MarketListCell
        let item = self.cellViewModels[indexPath.row]
        cell.currentTicker = item
        cell.lblIndexNo.text = "\(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MarketListHeaderView.identifier)
        return view
    }
}

extension MarketListModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectItem!(tableView, indexPath, self.cellViewModels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.cellViewModels.count != 0 {
            return 44
        }
        return 0
    }
}
