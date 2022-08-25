//
//  HomeHeaderCell.swift
//  Cryptonomy
//
//

import UIKit
import Charts
import Kingfisher
import Alamofire
import SwiftyUserDefaults

class HomeHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var coinImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblChange: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var currentTicker: Datum? {
        didSet {
            if currentTicker?.id == oldValue?.id {
                return
            }
            apiMgr.getHomeHeaderChartData(symbol: (currentTicker?.symbol)!, success: { coinDetail in
                self.updateChartData(coinDetail: coinDetail)
            }, failure: { message in
                
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewWithTag(111)?.layer.cornerRadius = 20.0
        self.viewWithTag(111)?.layer.masksToBounds = true
        
        self.commonInitChartInitialization()
    }
    
    func updateChartData(coinDetail: CoinDetail) {
        var arrChartDataEntry: [ChartDataEntry] = []
        for item in coinDetail.data {
            let entry = ChartDataEntry(x: Double(item.time), y: item.open)
            arrChartDataEntry.append(entry)
        }
        
        let set = LineChartDataSet(entries: arrChartDataEntry, label: "")
        set.axisDependency = .left
        set.setColor(UIColor.c_Blue)
        set.lineWidth = 0.5
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.drawCircleHoleEnabled = false
        set.mode = .cubicBezier
        
        let gradientColors = [UIColor.lightGray.cgColor,UIColor.lightGray.cgColor] as CFArray
//        let colorLocations:[CGFloat] = [1.0, 0.0]
//        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
//        set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
//        set.fillAlpha = 1

//        let gradientColors = [ChartColorTemplates.colorFromString("#34CAAE").withAlphaComponent(0.1).cgColor,
//                              ChartColorTemplates.colorFromString("#34CAAE").withAlphaComponent(0.1).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set.fillAlpha = 0.08
        set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        chartView.data = data
        chartView.minOffset = 0
        chartView.animate(xAxisDuration: 0.0)
        chartView.isUserInteractionEnabled = false
    }
    
    func setCurrentTicker(data: Datum) {
        self.currentTicker = data
        
        lblName.text = data.name
        
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(data.id).png")!
        coinImgView.kf.setImage(with: url)
        
        /*
        if let image = data.coinImageUrl {
            let url = URL(string: image)
            coinImgView.kf.setImage(with: url)
        } else {
            coinImgView.image = #imageLiteral(resourceName: "placeholder")
        }
        */
        if let usd = Common.getCurrentPriceData(data) {
            lblPrice.text = "1 \(data.symbol!) = " + usd.price.priceFromDouble()
            lblChange.text = "Change - (\((usd.percentChange24H ?? 0).toString())"  + "%)"
            lblChange.textColor = Float((usd.percentChange24H ?? 0)) >= 0 ? UIColor.c_Green : UIColor.c_Red
        }
    }
    
    func commonInitChartInitialization() {
        chartView.noDataText = ""
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.legend.enabled = false
        
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.form = .line
    }
}
