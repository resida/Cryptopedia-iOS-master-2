//
//  HomeListModel.swift
//  Cryptonomy
//
//

import UIKit
import PKHUD
import SwiftyUserDefaults

typealias didSelectItemInCollection = (( _ collectionView: UICollectionView, _ indexPath: IndexPath, _ rawList: Datum) -> ())?
typealias didSelectItemInList = (( _ tableView: UITableView,_ indexPath: IndexPath,_ news: DatumCoinNews) -> ())?

typealias recentNewsCompletion = (()->())?

class HomeListModel: NSObject {
    var didSelectCollectionItem : didSelectItemInCollection = nil
    var didSelectTableItem: didSelectItemInList = nil
    
    var errorOccured: ((String)->())? = nil
    
    var reloadvarleViewClosure:(()->())? = nil
    var reloadCollectionViewClosure:(()->())? = nil
    
    var coinHistoData: [Datum] = [Datum]() {
        didSet {
            self.reloadCollectionViewClosure!()
        }
    }
    var coinNewsData: [DatumCoinNews] = []
    
    override init() {
        super.init()
    }
    
    func fetchTopRecentNews(animated: Bool = true, completion: recentNewsCompletion) {
        if animated { Common.showLoading() }
        apiMgr.getCoinNewsData(success: { coinDetail in
            self.coinNewsData = coinDetail
            completion!()
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
            Common.hideLoading()
        })
    }
    
    func fetchHomeHeaderDataPro(animated: Bool = true) {
        //if animated { Common.showLoading() }
        if animated { Common.showLoading() }
        let params = TickerParams()
        params.limit = "10"
        params.convert = Defaults[.currentCurrency]!
        
        apiMgr.getHomeHeaderDataCoinMarketCapPro(params, success: { (result) in
            DispatchQueue.main.async {
                self.coinHistoData = result
            }
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
            Common.hideLoading()
        })
    }
}

extension HomeListModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coinHistoData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.identifier, for: indexPath) as! HomeHeaderCell
        cell.setCurrentTicker(data: self.coinHistoData[indexPath.item])        
        return cell
    }
}

extension HomeListModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        self.didSelectCollectionItem!(collectionView, indexPath, self.coinHistoData[indexPath.item])
    }
}

extension HomeListModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinNewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailNewsCell.identifier) as! DetailNewsCell
        cell.setCoinNews = self.coinNewsData[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 15.0, y: 8, width: 100, height: 21))
        label.text = self.coinNewsData.count > 0 ? "News" : ""
        label.font = UIFont.circularMedium(16.0)
        label.textColor = .black
        view.addSubview(label)
        
        return view
    }
}

extension HomeListModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectTableItem!(tableView, indexPath, self.coinNewsData[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
