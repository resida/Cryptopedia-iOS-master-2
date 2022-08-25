//
//  PortfolioListCell1.swift
//  Cryptonomy
//
//

import UIKit

class PortfolioListCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var coinImgView: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblNoOfCoins: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainView.layer.cornerRadius = 5.0
        mainView.layer.masksToBounds = true
        
        mainView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        mainView.layer.borderWidth = 1.0
    }
}
