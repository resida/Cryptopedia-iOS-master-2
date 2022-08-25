//
//  ChartView.swift
//  Cryptonomy
//

import UIKit
import Charts
import SwiftyUserDefaults

enum ChartType: Int {
    case Type6H
    case Type12H
    case Type24H
    case Type1Week
    case Type1Month
    case Type3Months
    case Type1Year
}

enum WebCallType {
    case CallTypeMinute
    case CallTypeHour
    case CallTypeDay
}

enum ChartDisplayType {
    case LineChartView
    case CandleChartView
}

class DetailChartType {
    let title: String
    let initialTitle: String
    let type: ChartType
    let apiType: WebCallType
    var isSelected: Bool
    
    init(title: String, initialTitle: String, type: ChartType, apiType: WebCallType, isSelected: Bool) {
        self.title = title
        self.initialTitle = initialTitle
        self.type = type
        self.apiType = apiType
        self.isSelected = isSelected
    }
}

class ChartView: UITableViewHeaderFooterView {
    
    //MARK: - IBOutlets
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var candleStickChartView: CandleStickChartView!
    @IBOutlet var barChartView: BarChartView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    //MarketCapView
    @IBOutlet weak var lblmarketCap: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblPast24hours: UILabel!
    @IBOutlet var btnAddPortfolio: UIButton!
    
    @IBOutlet var btnLineChart: UIButton!
    @IBOutlet var btnCandleChart: UIButton!
    
    //MARK: - Public Variables
    var datum: Datum!
    var currentCoinDetail: CoinDetail!
    var arrCollections = [DetailChartType]()
    var selectedTimeline : DetailChartType!
    var chartDisplayType : ChartDisplayType = .LineChartView {
        didSet {
            btnLineChart.isSelected = false
            btnCandleChart.isSelected = false
            
            chartView.isHidden = true
            candleStickChartView.isHidden = true
            barChartView.isHidden = true
            
            if chartDisplayType == .LineChartView {
                btnLineChart.isSelected = true
                chartView.isHidden = false
            } else {
                btnCandleChart.isSelected = true
                candleStickChartView.isHidden = false
                barChartView.isHidden = false
            }
        }
    }
    
    fileprivate let marketDetailModel = MarketDetailModel()
    
    //MARK: - Awake From Nib
    
    fileprivate func addtoPortfolioButtonSettings() {
        btnAddPortfolio.layer.cornerRadius = 8.0
        btnAddPortfolio.layer.masksToBounds = true
        btnAddPortfolio.setTitle("Add to portfolio", for: .normal)
        btnAddPortfolio.setTitleColor(UIColor.white, for: .normal)
        btnAddPortfolio.setTitleColor(UIColor.white, for: .highlighted)
        btnAddPortfolio.backgroundColor = UIColor.c_Blue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        allChartsCollectionInitialization()
        commonInitChartInitialization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchHistoricalDataMinute(_forCollection: 0)
            self.initializeMarketCapView()
        }
        
        initializeCollectionView()
        addtoPortfolioButtonSettings()
        
        self.chartDisplayType = .LineChartView
        
        self.viewWithTag(111)?.backgroundColor = UIColor.c_CommonDarkColor
        self.chartView.backgroundColor = UIColor.c_CommonDarkColor
        self.candleStickChartView.backgroundColor = UIColor.c_CommonDarkColor
    }
    
    //MARK: - All Charts Data Initialization
    
    func allChartsCollectionInitialization() {
        let data1 = DetailChartType(title: "6H", initialTitle: "Past 6 Hours", type: .Type6H, apiType: .CallTypeMinute, isSelected:true)
        let data2 = DetailChartType(title: "12H", initialTitle: "Past 12 Hours", type: .Type12H, apiType: .CallTypeMinute, isSelected:false)
        let data3 = DetailChartType(title: "24H", initialTitle: "Past 24 Hours", type: .Type24H, apiType: .CallTypeMinute, isSelected:false)
        let data4 = DetailChartType(title: "1W", initialTitle: "Past Week", type: .Type1Week, apiType: .CallTypeHour, isSelected:false)
        let data5 = DetailChartType(title: "1M", initialTitle: "Past Month", type: .Type1Month, apiType: .CallTypeDay, isSelected:false)
        let data6 = DetailChartType(title: "3M", initialTitle: "Past 3 Months", type: .Type3Months, apiType: .CallTypeDay, isSelected:false)
        let data7 = DetailChartType(title: "1Y", initialTitle: "Past Year", type: .Type1Year, apiType: .CallTypeDay, isSelected:false)
        
        arrCollections = [data1, data2, data3, data4, data5, data6, data7]
        
        marketDetailModel.arrCollections = arrCollections;
        selectedTimeline = arrCollections.first
    }
    
    //MARK:- Common Init
    
    func commonInitChartInitialization() {
        if self.datum != nil {
            lblAverage.text = "Average - \(String(describing: self.datum.symbol))/USD"
        }
        
        initializeLineChart()
        initializeCandleStickChart()
        initializeBarChart()
    }
    
    //MARK: - Initialize All Charts
    
    func initializeLineChart() {
        chartView.delegate = self
        chartView.noDataText = ""
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.circularMedium(12.0)
        xAxis.labelTextColor = UIColor.c_ChartTypeDefaultColor
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularityEnabled = false
        xAxis.avoidFirstLastClippingEnabled = true
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.form = .line
    }
    
    func initializeCandleStickChart() {
        candleStickChartView.delegate = self
        candleStickChartView.noDataText = ""
        candleStickChartView.chartDescription?.enabled = false
        candleStickChartView.dragEnabled = true
        
        candleStickChartView.setScaleEnabled(false)
        candleStickChartView.pinchZoomEnabled = false
        candleStickChartView.highlightPerDragEnabled = true
        candleStickChartView.legend.enabled = false
        
        candleStickChartView.rightAxis.enabled = false
        candleStickChartView.leftAxis.enabled = false
        candleStickChartView.xAxis.enabled = false
        candleStickChartView.legend.form = .line
    }
    
    func initializeBarChart() {
        barChartView.delegate = self
        barChartView.noDataText = ""
        barChartView.chartDescription?.text = ""
        barChartView.dragEnabled = true
        
        barChartView.chartDescription?.enabled = false
        barChartView.setScaleEnabled(false)
        barChartView.pinchZoomEnabled = false
        barChartView.highlightPerDragEnabled = true
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.legend.enabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.circularMedium(12.0)
        xAxis.labelTextColor = UIColor.c_ChartTypeDefaultColor
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularityEnabled = false
        xAxis.avoidFirstLastClippingEnabled = true
        
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
    }
    
    //MARK: - Button tap events
    
    @IBAction func btnChartTypeTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            self.chartDisplayType = .LineChartView
        } else {
            self.chartDisplayType = .CandleChartView
        }
    }
    
    //MARK: - Update Chart Data
    
    func updateChartData() {
        self.lblTime.text = self.selectedTimeline.initialTitle

        self.updateLineChartData()
        self.updateCandleStickChartData()
        self.updateBarChartData()
    }
    
    func updateLineChartData() {
        var arrChartDataEntry: [ChartDataEntry] = []
        for (index, item) in self.currentCoinDetail.data.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: item.open)
            arrChartDataEntry.append(entry)
        }
        
        let set1 = LineChartDataSet(entries: arrChartDataEntry, label: "")
        set1.axisDependency = .left
        set1.setColor(UIColor.c_Blue)
        set1.lineWidth = 2.0
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 1
        set1.fillColor = UIColor.white
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = false
        set1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(UIColor.white)
        data.setValueFont(UIFont.circularMedium(12.0))
        
        let timeIntervals = self.currentCoinDetail.data.map { return $0.time }
        var chartFormatter: DayAxisValueFormatter? = nil
        if selectedTimeline.type == .Type6H || selectedTimeline.type == .Type12H || selectedTimeline.type == .Type24H {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "ha")
        } else {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "M/d")
        }
        
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        
        chartView.notifyDataSetChanged()
        chartView.data = data
    }
    
    func updateCandleStickChartData(){
        var arrCandleChartDataEntry: [CandleChartDataEntry] = []
        for (index, item) in self.currentCoinDetail.data.enumerated() {
            let high = item.high
            let low = item.low
            let open = item.open
            let close = item.close
            arrCandleChartDataEntry.append(CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close))
        }
        
        let set2 = CandleChartDataSet(entries: arrCandleChartDataEntry, label: "")
        set2.axisDependency = .left
        set2.drawIconsEnabled = false
        set2.drawValuesEnabled = false
        set2.highlightColor = UIColor.white
        set2.increasingColor = UIColor.c_ChartTypeSelectedColor
        set2.decreasingColor = UIColor.c_Red
        set2.increasingFilled = true
        set2.decreasingFilled = true
        set2.neutralColor = .blue
        
        let data1 = CandleChartData(dataSet: set2)
        
        let timeIntervals = self.currentCoinDetail.data.map { return $0.time }
        var chartFormatter: DayAxisValueFormatter? = nil
        if selectedTimeline.type == .Type6H || selectedTimeline.type == .Type12H || selectedTimeline.type == .Type24H {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "ha")
        } else {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "M/d")
        }
        
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        candleStickChartView.xAxis.valueFormatter = xAxis.valueFormatter

        candleStickChartView.xAxis.enabled = false
        candleStickChartView.data = data1
        candleStickChartView.animate(xAxisDuration: 0.0)
    }
    
    func updateBarChartData() {
        var arrChartDataEntry: [BarChartDataEntry] = []
        
        for (index, item) in self.currentCoinDetail.data.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: item.open)
            arrChartDataEntry.append(entry)
        }
        
        let set3 = BarChartDataSet(entries: arrChartDataEntry, label: "")
        set3.axisDependency = .left
        set3.drawValuesEnabled = false
        set3.drawIconsEnabled = false
        set3.colors = self.colors()
        
        let data = BarChartData(dataSet: set3)
        
        let timeIntervals = self.currentCoinDetail.data.map { return $0.time }
        var chartFormatter: DayAxisValueFormatter? = nil
        if selectedTimeline.type == .Type6H || selectedTimeline.type == .Type12H || selectedTimeline.type == .Type24H {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "ha")
        } else {
            chartFormatter = DayAxisValueFormatter(labels: timeIntervals, format: "M/d")
        }
        
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        barChartView.xAxis.valueFormatter = xAxis.valueFormatter
        barChartView.xAxis.enabled = true
        
        barChartView.notifyDataSetChanged()
        barChartView.data = data
    }
    
    func colors() -> [NSUIColor] {
        let color = NSUIColor(red: 52, green: 202, blue: 174, alpha: 0.1)
        return [color]
    }
    
    //MARK: - CollectionView & Market cap View Intialization
    
    func initializeCollectionView() {
        collectionView.dataSource = marketDetailModel
        collectionView.delegate = marketDetailModel
        collectionView.register(TimelineCollectionCell.nib, forCellWithReuseIdentifier: TimelineCollectionCell.identifier)
        
        marketDetailModel.didSelectItem = { (collectionView, indexPath, aData) in
            
            self.arrCollections.forEach { $0.isSelected = false }
            aData.isSelected = true
            self.selectedTimeline = aData
            self.lblTime.text = aData.initialTitle
            self.fetchHistoricalDataMinute(_forCollection: indexPath.item)
            self.collectionView.reloadData()
        }
    }
    
    func initializeMarketCapView(){
        guard let data = self.datum else {
            self.lblmarketCap.text = "-"
            self.lblVolume.text = "-"
            self.lblPast24hours.text = "_"
            return
        }
        
        guard let usd = Common.getCurrentPriceData(data) else {
            let tmpUsd = data.quote.usd!
            
            self.lblmarketCap.text = tmpUsd.marketCap?.formatNumberCurrencyUSD()
            self.lblVolume.text = tmpUsd.volume24H?.formatNumberCurrencyUSD()
            self.lblPrice.text = "\(tmpUsd.price.priceFromDoubleUSD())"
            
            self.lblPast24hours.text = "\((tmpUsd.percentChange24H ?? 0).toString())"  + "%"
            self.lblPast24hours.textColor = Float((tmpUsd.percentChange24H ?? 0)) >= 0 ? UIColor.c_Green : UIColor.c_Red

            return
        }
        
        self.lblmarketCap.text = usd.marketCap?.formatNumberCurrency()
        self.lblVolume.text = usd.volume24H?.formatNumberCurrency()
        self.lblPrice.text = "\(usd.price.priceFromDouble())"
        
        self.lblPast24hours.text = "\((usd.percentChange24H ?? 0).toString())"  + "%"
        self.lblPast24hours.textColor = Float((usd.percentChange24H ?? 0)) >= 0 ? UIColor.c_Green : UIColor.c_Red
    }
    
    //MARK:- Fetch Historical Data Market Detail Model
    
    func fetchHistoricalDataMinute(_forCollection:Int) {
        marketDetailModel.errorOccured = { message in
            print(message)
        }
        
        let type1 = arrCollections[_forCollection]
        if self.datum != nil {
            marketDetailModel.fetchCoinDetailByChartType(symbol: datum.symbol!, chartType: type1) { coinDetail in
                self.currentCoinDetail = coinDetail
                self.updateChartData()
            }
        }
    }
}

extension ChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let formatter =  chartView.xAxis.valueFormatter as! DayAxisValueFormatter
        let index = Int(highlight.x)
        
        self.lblPrice.text = highlight.y.priceFromDouble()
        if selectedTimeline.type == .Type6H || selectedTimeline.type == .Type12H || selectedTimeline.type == .Type24H {
            self.lblTime.text = "\(Common.getCurrentTimeFromTimeStamp(Double(formatter.labels[index]), "hh:mma"))"
        } else if selectedTimeline.type == .Type1Week {
            self.lblTime.text = "\(Common.getCurrentTimeFromTimeStamp(Double(formatter.labels[index]), "hh:mm a MMM d"))"
        } else {
            self.lblTime.text = "\(Common.getCurrentTimeFromTimeStamp(Double(formatter.labels[index]), "MMM d, yyyy"))"
        }
    }
}

