//
//  MarketListCell.swift
//  Cryptonomy
//
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyUserDefaults

class MarketListCell: UITableViewCell {
    
    @IBOutlet weak var lblIndexNo: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblChange: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    
    func setCurrentTickerFromWebApiCall(ticker: Datum, indexPath: IndexPath) {
        self.currentTicker = ticker
        self.lblIndexNo.text = "\(indexPath.row+1)"
        
        if ticker.isListUpdated == nil || ticker.isListUpdated == false {
            print("Web Api Calling for \(String(describing: ticker.symbol)) and id \(ticker.id)")
            
            if !APIManager.Connectivity.isConnectedToInternet {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let url = APIConstants.baseUrl + "/ticker/" + "\(ticker.id)/?structure=array"
            Alamofire.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<MarketListResponse>) in
                    if completion.result.error == nil {
                        if let arrData = completion.result.value?.data {
                            print("Response for \(String(describing: ticker.symbol))")
                            
                            self.currentTicker = arrData.first
                            self.currentTicker.coinImageUrl = ticker.coinImageUrl
                            self.currentTicker.isListUpdated = true
                            
                            self.lblIndexNo.text = "\(indexPath.row+1)"
                            if let image = self.currentTicker.coinImageUrl {
                                let url = URL(string: image)
                                self.coinImage.kf.setImage(with: url)
                            } else {
                                self.coinImage.image = #imageLiteral(resourceName: "placeholder")
                            }
                        }
                    }
            }
        }
    }
    
    func setMarketListTicker(ticker: Datum, indexPath: IndexPath) {
        currentTicker = ticker
        
        self.updateUI()
        lblIndexNo.text = "\(indexPath.row+1)"
    }
    
    var currentTicker: Datum! {
        didSet { updateUI() }
    }
    
    func updateUI() {
        
        lblName.text = currentTicker.name
        
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(currentTicker.id).png")!
        coinImage.kf.setImage(with: url)
        
//        if let image = currentTicker.coinImageUrl {
//            let url = URL(string: image)
//            coinImage.kf.setImage(with: url)
//        } else {
//            coinImage.image = #imageLiteral(resourceName: "placeholder")
//        }
        
        let usd = Common.getCurrentPriceData(currentTicker)!
        lblPrice.text = usd.price.priceFromDouble()
        lblChange.text = "\((usd.percentChange24H ?? 0).toString())"  + "%"
        lblChange.textColor = Float((usd.percentChange24H ?? 0)) >= 0 ? UIColor.c_Green : UIColor.c_Red
        
        if let marketCap = usd.marketCap {
            lblMarketCap.text = marketCap.formatNumberCurrency()
        } else {
            lblMarketCap.text = "-"
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
