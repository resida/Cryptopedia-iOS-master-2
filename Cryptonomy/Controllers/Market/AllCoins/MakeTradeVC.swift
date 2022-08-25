//
//  MakeTradeVC.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults

class MakeTradeVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var segmentTradePage: UISegmentedControl!
    @IBOutlet var lblPricePerCoin: UILabel!
    @IBOutlet var txtPricePerCoin: CryptoTextField!
    @IBOutlet var txtAmountCoin: CryptoTextField!
    @IBOutlet var lblTotalPriceTrade: UILabel!
    @IBOutlet var btnAddTransaction: UIButton!

    //MARK: - Public Variables
    var datum: Datum!
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutInitialization()
        self.configureSegment()
    }
    
    //MARK: - Design Initialization
    
    func layoutInitialization() {
        guard let name = datum.name else { return }
        
        title = name
        
        txtPricePerCoin.layer.cornerRadius = 2.0
        txtPricePerCoin.layer.masksToBounds = true
        
        txtPricePerCoin.layer.borderWidth = 1.0
        txtPricePerCoin.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor        
        
        txtAmountCoin.layer.cornerRadius = 2.0
        txtAmountCoin.layer.masksToBounds = true
        
        txtAmountCoin.layer.borderWidth = 1.0
        txtAmountCoin.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        btnAddTransaction.layer.cornerRadius = 8.0
        btnAddTransaction.layer.masksToBounds = true
        
        btnAddTransaction.setTitle("Add transaction", for: .normal)
        btnAddTransaction.setTitleColor(.white, for: .normal)
        btnAddTransaction.setTitleColor(.white, for: .highlighted)
        btnAddTransaction.backgroundColor = .c_Blue
        
        segmentTradePage.tintColor = .c_Blue
    }
    
    func configureSegment() {        
        segmentTradePage.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.circularMedium(15.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        
        segmentTradePage.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.circularMedium(15.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
    }

    //MARK: - Button tap events
    
    @IBAction func btnAddTransactionTapped(_ sender: Any) {
        let type = segmentTradePage.selectedSegmentIndex == 0 ? "Buy" : "Sell"
        
        let price = String( txtPricePerCoin.text!.split(separator: ",").joined(separator: ["."]) )
        let amount = String( txtAmountCoin.text!.split(separator: ",").joined(separator: ["."]) )
        
        if txtPricePerCoin.text != "" && txtAmountCoin.text != "" {
            let trade = Trade(coinSymbol: datum.symbol!,
                              coinPriceBought: price,
                              totalPrice: lblTotalPriceTrade.text!,
                              amountBought: amount,
                              timeStamp: String(describing: NSDate()),
                              type: type)
            PortfolioManager.shared.appendNewTrade(trade: trade)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func priceDidChange(_ sender: UITextField) {
        if sender.text != "" && txtAmountCoin.text != "" {
            let price = String( sender.text!.split(separator: ",").joined(separator: ["."]) )
            let amount = String( txtAmountCoin.text!.split(separator: ",").joined(separator: ["."]) )
            
            lblTotalPriceTrade.text = String( Double(price)! * Double(amount)! )
        }
    }
    
    @IBAction func amountDidChange(_ sender: UITextField) {
        if sender.text != "" && txtPricePerCoin.text != "" {
            let price = String( txtPricePerCoin.text!.split(separator: ",").joined(separator: ["."]) )
            let amount = String( sender.text!.split(separator: ",").joined(separator: ["."]) )
            
            lblTotalPriceTrade.text = String( Double(price)! * Double(amount)! )
        }
    }
}
