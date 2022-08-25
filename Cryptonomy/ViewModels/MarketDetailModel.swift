//
//  MarketDetailModel.swift
//  Cryptonomy
//


import UIKit
import PKHUD
import SwiftyUserDefaults
import FirebaseDatabase
import TTTAttributedLabel

typealias didSelectRowAtIndex = ((_ tableView: UITableView, _ indexPath: IndexPath, _ aData: DatumCoinNews) -> ())?
typealias didSelectItemAtIndex = ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ rawList: DetailChartType) -> ())?
typealias addPortfolioSection = ((_ datum: Datum)->())?

class MarketDetailModel: NSObject {
   
    var didSelectItem: didSelectItemAtIndex = nil
    var didSelectRow: didSelectRowAtIndex = nil
    var addPortfolioEvent: addPortfolioSection = nil
    
    var errorOccured: ((String)->())? = nil
    var didTapOnMoreNews: (()->())? = nil
    var didTapOnRedFlags: (()->())? = nil
    
    var arrCollections = [DetailChartType]()
    var arrNews = [DatumCoinNews]()
    var arrCoinInfo: [CoinInfo] = []
    var arrNetworks: [Network] = []
    var arrRedFlags: [String] = []
    
    var datum: Datum!
    
    override init() {
        super.init()
    }
    
    //MARK: - Fetch Coin Detail By Chart Type
    
    func fetchCoinDetailByChartType(symbol: String, chartType: DetailChartType, showLoading: Bool = true, success: @escaping (_ resule: CoinDetail) -> ()) {
        var params = Params()
        let tsyms = Defaults[.currentCurrency]!
        if chartType.type == .Type6H {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 72, aggregate: 5)
        } else if chartType.type == .Type12H {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 72, aggregate: 10)
        } else if chartType.type == .Type24H {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 48, aggregate: 30)
        } else if chartType.type == .Type1Week {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 56, aggregate: 3)
        } else if chartType.type == .Type1Month {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 30, aggregate: 1)
        } else if chartType.type == .Type3Months {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 90, aggregate: 1)
        } else if chartType.type == .Type1Year {
            params = Params(fsyms: symbol, tsyms: tsyms, limit: 52, aggregate: 7)
        }
        
        apiMgr.getCoinDetailHistoricalData(params: params, detailChartType: chartType, success: { coinDetail in
            success(coinDetail)
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
        })
    }
    
    //MARK: - Fetch Coin News
    
    func fetchCoinNews(showLoading: Bool = true, success: @escaping (_ resule: [DatumCoinNews]) -> ()) {
        apiMgr.getCoinNewsData(success: { coinDetail in
            success(coinDetail)
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
        })
    }
    
    func fetchCoinSpecificNews(symbol: String, success: @escaping (_ resule: [DatumCoinNews]) -> ()) {
        apiMgr.getCoinSpecificNews(symbol: symbol, success: { coinDetail in
            self.arrNews = coinDetail
            success(coinDetail)
        }, failure: { message in
            if let error = self.errorOccured { error(message) }
        })
    }
    
    //MARK: - We are not using it
    
    func fetchCoinSnapshot(of Id: String, success: @escaping (_ result: CoinInfoResponse) -> ()) {
        apiMgr.getCoinSnapshotById(Id, success: { (infoResponse) in
            self.arrCoinInfo = infoResponse.arrCoinInfo
        }, failure: { message in

        })
    }
    
    //MARK: - Fetch CoinSnapShot data from Firebase
    
    func fetchDataFromFirebase(completion: @escaping (()->())) {
        let ref = Database.database().reference()
        ref.child("coinsnapshot").child((self.datum.symbol?.lowercased())!).observeSingleEvent(of: .value, with: { (snapshot) in
            let coinInfoResponse = CoinInfoResponse(withSnapshot: snapshot)
            self.arrCoinInfo = coinInfoResponse.arrCoinInfo
            self.arrNetworks = coinInfoResponse.arrNetworks
            self.arrRedFlags = coinInfoResponse.arrRedFlags
            completion()
        })
    }
    
    //MARK: - Fetch Coin Network Info
    
    func fetchNetworkInfoFromFirebase(completion: @escaping (()->())) {
        self.arrNetworks.removeAll()
        let ref = Database.database().reference()
        ref.child("networks").child((self.datum.symbol?.lowercased())!).observeSingleEvent(of: .value, with: { snapshot in
            if let json = snapshot.value as? [String: AnyObject] {
                for item in json.keys {
                    if let value = json[item] as? String, value != "" { self.arrNetworks.append(Network(key: item, value: value)) }
                }
            }
            completion()
        })
    }
    
    //MARK: - Button tap events
    
    @objc func btnAddPortfolioTapped(_ sender: UIButton) {
        addPortfolioEvent!(self.datum)
    }
    
    @objc func btnMoreNewsTapped(_ sender: UIButton) {
        self.didTapOnMoreNews?()
    }

    @objc func btnRedFlagsTapped(_ sender: UIButton) {
        self.didTapOnRedFlags?()
    }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> CoinInfoCell {
        let info = self.arrCoinInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinInfoCell.identifier, for: indexPath) as! CoinInfoCell
        self.setValueAtIndexPath(cell: cell, info: info)
        return cell
    }
    
    func setValueAtIndexPath(cell: CoinInfoCell, info: CoinInfo) {
        cell.lblKey.text = info.key?.replacingOccurrences(of: "_", with: " ").capitalized
        if info.value == nil {
            let object = info.object
            self.setAttributedText(at: cell.lblValue, text: object["displayText"]!, url: object["url"]!)
        } else {
            self.defaultAttributes(at: cell.lblValue, text: info.value!)
        }
    }
    
    @objc func linkTapped(_ gesture: UITapGestureRecognizer) {
        let value = gesture.value(forKey: "url")
        let url = URL(string: value as! String)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    func attributes() ->  [NSAttributedString.Key: Any] {
        let linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.c_Blue,
            NSAttributedString.Key.font: UIFont.circularMedium(15.0)
            ] as [NSAttributedString.Key : Any]
        return linkAttributes
    }
}

extension MarketDetailModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.arrNews.count < 4 { return self.arrNews.count }
            else { return 5 }
        } else if section == 2 {
            return self.arrCoinInfo.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:MarketDetailNewsCell.identifier) as! MarketDetailNewsCell
                cell.setCoinNews = self.arrNews[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:DetailNewsCell.identifier) as! DetailNewsCell
                cell.setCoinNews = self.arrNews[indexPath.row]
                return cell
            }
        } else if indexPath.section == 2 {
            let info = self.arrCoinInfo[indexPath.row]
            if indexPath.row == 0 {
                if info.key == "about", info.value != "" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: AboutCoinCell.identifier, for: indexPath) as! AboutCoinCell
                    let value = info.value?.html2String
                    cell.lblDescription.attributedText = NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 5.0, text: value!, font: UIFont.circularBook(14.0), fontColor: UIColor.c_CommonDarkColor)
                    cell.separatorInset = UIEdgeInsets.init(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
                    return cell
                } else {
                    return createCell(tableView:tableView, indexPath:indexPath)
                }
            } else if indexPath.row == 1 {
                if info.key == "paperUrl", info.value != "" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CoinInfoCell.identifier, for: indexPath) as! CoinInfoCell
                    self.setAttributedText(at: cell.lblKey, text: "READ THE WHITEPAPER", url: info.value!, isKey: true)
                    cell.lblValue.text = ""
                    return cell
                } else {
                    return createCell(tableView:tableView, indexPath:indexPath)
                }
            } else {
                return createCell(tableView:tableView, indexPath:indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func setAttributedText(at label: TTTAttributedLabel, text: String, url: String, isKey: Bool = false) {
        let linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.c_Blue,
            NSAttributedString.Key.font: isKey ? UIFont.circularMedium(16.0) : UIFont.circularBook(16.0)
            ] as [NSAttributedString.Key : Any]
        
        let tmpText = isKey ? text.uppercased() as NSString : text as NSString
        let range = tmpText.range(of: tmpText as String)
        
        let attributedText = NSAttributedString(string: text)
        label.text = isKey ? text.uppercased() : text.replacingOccurrences(of: "_", with: " ").capitalized
        label.attributedText = attributedText
        label.linkAttributes = linkAttributes
        label.activeLinkAttributes = linkAttributes
        label.addLink(to: URL(string: url)!, with: range)
        label.delegate = self
    }
    
    func defaultAttributes(at label: TTTAttributedLabel, text: String) {
        let linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.c_CommonDarkColor,
            NSAttributedString.Key.font: UIFont.circularBook(16.0)
            ] as [NSAttributedString.Key : Any]
        
        let attributedText = NSAttributedString(string: text, attributes: linkAttributes)
        label.text = text
        label.attributedText = attributedText
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChartView.identifier) as! ChartView
            view.datum = self.datum
            view.btnAddPortfolio.addTarget(self, action: #selector(btnAddPortfolioTapped(_:)), for: .touchUpInside)
            return view
        } else if section == 3 {
            if self.arrRedFlags.count != 0 {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RedFlagsView.identifier) as! RedFlagsView
                view.btnRedFlags.addTarget(self, action: #selector(btnRedFlagsTapped(_:)), for: .touchUpInside)
                view.btnRedFlags.setTitleColor(.c_CommonDarkColor, for: .normal)
                return view
            }
            return nil
        } else if section == 4 {
            if self.arrNetworks.count != 0 {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SocialStateView.identifier) as! SocialStateView
                view.arrNetworkInfo = self.arrNetworks
                return view
            }
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsFooterView.identifier) as! NewsFooterView
            view.btnMoreNews.addTarget(self, action: #selector(btnMoreNewsTapped(_:)), for: .touchUpInside)
            view.btnMoreNews.setTitle("MORE \(self.datum.name?.uppercased() ?? "") NEWS", for: .normal)
            view.btnMoreNews.setTitleColor(.c_Blue, for: .normal)
            return view
        }
        return nil
    }
}

extension MarketDetailModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            didSelectRow!(tableView, indexPath, self.arrNews[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 580 }
        else if section == 1 { return self.arrNews.count != 0 ? 5 : 0 }
        else if section == 2 { return self.arrCoinInfo.count != 0 ? 5 : 0 }
        else if section == 3 { return self.arrRedFlags.count != 0 ? 50 : 0 }
        else { return self.arrNetworks.count != 0 ? 140 : 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        else if section == 1 { return 50 }
        else if section == 2 { return self.arrCoinInfo.count != 0 ? 5 : 0 }
        else if section == 3 { return self.arrRedFlags.count != 0 ? 5 : 0 }
        else { return self.arrNetworks.count != 0 ? 5 : 0 }
    }
}


// MARK: - UICollectionViewDataSource protocol

extension MarketDetailModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimelineCollectionCell.identifier, for: indexPath as IndexPath) as! TimelineCollectionCell
        
        let aDetailChartType = self.arrCollections[indexPath.item]
        cell.lblTimeLine.text = aDetailChartType.title
        cell.lblTimeLine.textColor = aDetailChartType.isSelected ? UIColor.c_Blue : UIColor.c_ChartTypeDefaultColor
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol

extension MarketDetailModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem!(collectionView, indexPath, self.arrCollections[indexPath.row])
    }
}

extension MarketDetailModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.size.width) / self.arrCollections.count
        return CGSize(width: CGFloat(width), height: collectionView.frame.size.height)
    }
}

extension MarketDetailModel : TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
