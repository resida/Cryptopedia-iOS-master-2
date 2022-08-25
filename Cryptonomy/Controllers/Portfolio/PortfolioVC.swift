//
//  PortfolioVC.swift
//  Cryptonomy
//
//

import UIKit
import Charts
import SwiftyUserDefaults

class PortfolioVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var topChartView: UIView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var lblTotalProfit: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet var portfolioHeaderView: PortfolioHeaderView!
    @IBOutlet var lblNoData: UILabel!
    
    //MARK:- Public Variables
    var coins: [Datum] = []
    var portFolioDict: [String: NSDictionary] = [:]
    var ownedCoins: [Datum] = []
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.noDataText = ""
        
        portfolioTableView.register(PortfolioListCell.nib, forCellReuseIdentifier: PortfolioListCell.identifier)
        portfolioTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topChartView.isHidden = true
        self.portfolioTableView.isHidden = true
        let pShared = PortfolioManager.shared
        
        if pShared.arrPortfolios.count != 0 {
            self.lblNoData.isHidden = true
            if pShared.shouldCallPortfolioWebAPITimeStamp() {
                apiMgr.getAllPortfolioTickerData(TickerParams(), success: {
                    DispatchQueue.main.async {
                        self.updateUI(with: pShared.listResponse.data)
                    }                    
                }, failure: { message in
                    Common.showAlert("", message, self)
                })
            } else {
                self.updateUI(with: pShared.listResponse.data)
            }
        } else {
            self.lblNoData.isHidden = false
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datum = sender as? Datum else { return }
        
        if segue.identifier == "showMarketDetailVC" {
            let destination = segue.destination as! MarketDetailVC
            destination.datum = datum
        }
    }

    func updateUI(with coins: [Datum]) {
        self.topChartView.isHidden = false
        self.portfolioTableView.isHidden = false
        
        DispatchQueue.main.async {
            self.coins = coins
            self.makePortfolioDict(trades: PortfolioManager.shared.arrPortfolios)
        }
    }
    
    // Create a dict with buyprice, amount and tradeprofit per coin
    func makePortfolioDict(trades: [Trade]) {
        self.portFolioDict = [:]
        for trade in trades {
            var newTotalPrice: Double = 0.0
            var newTotalAmount: Double = 0.0
            
            if self.portFolioDict["\(trade.coinSymbol)"] == nil {
                if trade.type == "Buy" {
                    self.portFolioDict["\(trade.coinSymbol)"] = ["totalPrice": Double(trade.totalPrice)!, "amount": Double(trade.amountBought)!, "tradeProfit": 0.0 ]
                }
                else {
                    self.portFolioDict["\(trade.coinSymbol)"] = ["totalPrice": 0.0, "amount": 0, "tradeProfit": (Double(("-\(trade.totalPrice)" as NSString).doubleValue)) ]
                }
            } else {
                if trade.type == "Buy" {
                    newTotalPrice = ( (self.portFolioDict[trade.coinSymbol]!["totalPrice"]!) as! Double) + Double(trade.totalPrice)!
                    newTotalAmount = ( (self.portFolioDict[trade.coinSymbol]!["amount"]!) as! Double) + Double(trade.amountBought)!
                    
                    self.portFolioDict["\(trade.coinSymbol)"] = ["totalPrice": newTotalPrice, "amount": newTotalAmount, "tradeProfit": (Double(("-\(trade.totalPrice)" as NSString).doubleValue))]
                } else {
                    newTotalPrice = ((self.portFolioDict[trade.coinSymbol]!["totalPrice"]!) as! Double)
                    newTotalAmount = ((self.portFolioDict[trade.coinSymbol]!["amount"]!) as! Double) - Double(trade.amountBought)!
                    
                    self.portFolioDict["\(trade.coinSymbol)"] = ["totalPrice": newTotalPrice, "amount": newTotalAmount, "tradeProfit": ((portFolioDict[trade.coinSymbol]!["amount"]!) as! Double)+(Double(("\(trade.totalPrice)" as NSString).doubleValue)) ]
                }
            }
        }
        getPortfolioStats(portfolio: self.portFolioDict)
        updateChartData(portfolio: self.portFolioDict)
        getOwnedCoins()
        portfolioTableView.reloadData()
    }
    
    func getPortfolioStats(portfolio: [String: NSDictionary]) {
        var totalBuyPrice = 0.0
        var tradeProfit = 0.0
        var totalWorthNow = 0.0
        for item in portfolio {
            tradeProfit += (item.value["tradeProfit"]!) as! Double
            totalBuyPrice += (item.value["totalPrice"]!) as! Double
            for coin in self.coins {
                if item.key == coin.symbol {
                    totalWorthNow += ((coin.quote.usd?.price)! * ((item.value["amount"]!) as! Double))
                }
            }
        }
        lblTotalValue.text = String(totalWorthNow.formattedWithSeparator)
        let profit = String(format: "%.2f", (((totalWorthNow+tradeProfit-totalBuyPrice)/totalBuyPrice)*100)) + "%   " + String((totalWorthNow - totalBuyPrice + tradeProfit).formattedWithSeparator)
        if profit.starts(with: "-") {
            lblTotalProfit.textColor = UIColor.c_Red
        } else {
            lblTotalProfit.textColor = UIColor.c_Green
        }
        lblTotalProfit.text = profit
    }
    
    func updateChartData(portfolio: [String: NSDictionary])  {
        var allCoins = [String]()
        var allValues = [Double]()
        
        // Create data suitable for piechart
        for item in portfolio {
            if (portfolio[item.key]!["amount"]! as! Double) > 0.0 {
                allCoins.append(item.key)
                for coin in self.coins {
                    if item.key == coin.symbol {
                        allValues.append(((coin.quote.usd?.price)! * (portfolio[item.key]!["amount"]! as! Double)))
                    }
                }
            }
        }
        
        // Create data suitable for piechart
        var entries = [PieChartDataEntry]()
        for (index, value) in allValues.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = allCoins[index]
            entries.append( entry)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 2
        set.valueTextColor = UIColor.black
        let colors: [UIColor] = [UIColor(red: CGFloat(46.0/255), green: CGFloat(204.0/255), blue: CGFloat(113.0/255), alpha: 1),
                                 UIColor(red: CGFloat(52.0/255), green: CGFloat(152.0/255), blue: CGFloat(219.0/255), alpha: 1),
                                 UIColor(red: CGFloat(155.0/255), green: CGFloat(89.0/255), blue: CGFloat(182.0/255), alpha: 1),
                                 UIColor(red: CGFloat(26.0/255), green: CGFloat(188.0/255), blue: CGFloat(156.0/255), alpha: 1),
                                 UIColor(red: CGFloat(241.0/255), green: CGFloat(196.0/255), blue: CGFloat(15.0/255), alpha: 1),
                                 UIColor(red: CGFloat(230.0/255), green: CGFloat(126.0/255), blue: CGFloat(34.0/255), alpha: 1),
                                 UIColor(red: CGFloat(155.0/255), green: CGFloat(89.0/255), blue: CGFloat(182.0/255), alpha: 1),
                                 UIColor(red: CGFloat(231.0/255), green: CGFloat(76.0/255), blue: CGFloat(60.0/255), alpha: 1),
                                 UIColor(red: CGFloat(149.0/255), green: CGFloat(165.0/255), blue: CGFloat(166.0/255), alpha: 1),
                                 UIColor(red: CGFloat(52.0/255), green: CGFloat(73.0/255), blue: CGFloat(94.0/255), alpha: 1)]
        
        set.colors = colors
        set.valueFont = NSUIFont(name: "CircularStd-Book", size: 13.0)!
        set.valueTextColor = NSUIColor.white
        set.valueLineVariableLength = true
        
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        pieChartView.noDataText = ""
        pieChartView.chartDescription?.text = ""
        
        pieChartView.isUserInteractionEnabled = true
        pieChartView.legend.enabled = false
        
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.holeColor = UIColor.c_Blue
        pieChartView.transparentCircleRadiusPercent = 0.0
        pieChartView.usePercentValuesEnabled = true
        
        // Get percentage behind numbers in piechart
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    }
    
    func getOwnedCoins() {
        self.ownedCoins = []
        for item in self.portFolioDict {
            for coin in coins {
                if item.key == coin.symbol! && (self.portFolioDict[coin.symbol!]!["amount"]! as! Double) > 0.0 {
                    self.ownedCoins.append(coin)
                }
            }
        }
    }
}

extension PortfolioVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ownedCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioListCell") as! PortfolioListCell
        cell.selectionStyle = .none
        
        let coin = self.ownedCoins[indexPath.row]
        
        cell.lblCoinName.text = coin.name
        cell.lblNoOfCoins.text = String(self.portFolioDict[coin.symbol!]!["amount"]! as! Double)
        
        let usd = coin.quote.usd
        cell.lblPrice.text = usd?.price.priceFromDoubleUSD()
        cell.lblPrice.textColor = Float((usd?.percentChange24H ?? 0)) >= 0 ? UIColor.c_Green : UIColor.c_Red
        cell.lblTotal.text = String(((usd?.price)! * ((self.portFolioDict[coin.symbol!]!["amount"]!) as! Double)).formattedWithSeparator)
        
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(coin.id).png")!
        cell.coinImgView.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.portfolioHeaderView
    }
}

extension PortfolioVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.ownedCoins.count == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMarketDetailVC", sender: self.ownedCoins[indexPath.row])
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter
    }()
}

extension Double {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
