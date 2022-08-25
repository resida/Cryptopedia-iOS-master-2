//
//  IcoFinanceCell.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 29..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoFinanceCell
class IcoFinanceCell: UITableViewCell {
    // MARK: Static
    static let CellId = "IcoFinanceCell"
    
    // MARK: Outlet
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var tokensLabel: UILabel!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    @IBOutlet weak var hardcapLabel: UILabel!
    @IBOutlet weak var softcapLabel: UILabel!
    @IBOutlet weak var raisedLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var distributedLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var acceptingLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Function
extension IcoFinanceCell {
    func setData(finance: IcoFinance?) {
        self.tokenLabel.text = finance?.token
        self.priceLabel.text = finance?.price
        self.bonusLabel.text = (true == finance?.bonus) ? "Yes" : "No"
        self.tokensLabel.text = "\(finance?.tokens ?? 0)"
        self.tokenTypeLabel.text = finance?.tokentype
        self.hardcapLabel.text = finance?.hardcap
        self.softcapLabel.text = finance?.softcap
        self.raisedLabel.text = "\(finance?.raised ?? 0)"
        self.platformLabel.text = finance?.platform
        self.distributedLabel.text = finance?.distributed
        self.minimumLabel.text = finance?.minimum
        self.acceptingLabel.text = finance?.accepting
    }
}
