//
//  IcoSummaryCell.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 25..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoSummaryCell
class IcoSummaryCell: UITableViewCell {
    // MARK: Static
    static let CellId = "IcoSummaryCell"
    
    // MARK: Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: PrImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var preIcoTitleLabel: UILabel!
    @IBOutlet weak var preIcoDateLabel: UILabel!
    @IBOutlet weak var icoTitleLabel: UILabel!
    @IBOutlet weak var icoDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleImageView.layer.cornerRadius = 3.0
        self.titleImageView.layer.borderWidth = 0.5
        self.titleImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.preIcoTitleLabel.layer.cornerRadius = 3.0
        self.icoTitleLabel.layer.cornerRadius = 3.0
        self.ratingLabel.layer.cornerRadius = 3.0        
        self.selectionStyle = .none
    }
}

// MARK: - Function
extension IcoSummaryCell {
    func setData(
        name: String?,
        logo: String?,
        desc: String?,
        dates: IcoDates?,
        rating: Float,
        nameFont: UIFont? = nil,
        descFont: UIFont? = nil)
    {
        let preIcoStart = DateTimeUtil.changeIcoDateFormat(dateStr: dates?.preIcoStart)
        let preIcoEnd = DateTimeUtil.changeIcoDateFormat(dateStr: dates?.preIcoEnd)
        let icoStart = DateTimeUtil.changeIcoDateFormat(dateStr: dates?.icoStart)
        let icoEnd = DateTimeUtil.changeIcoDateFormat(dateStr: dates?.icoEnd)
        self.titleLabel.text = name
        self.titleLabel.font = nameFont ?? UIFont.circularMedium(17.0)
        self.titleImageView.setImageUrl(path: logo, placeHolder: nil)
        self.descriptionLabel.text = desc
        self.descriptionLabel.font = descFont ?? UIFont.circularBook(15.0)
        if nil == preIcoStart, nil == preIcoEnd {
            self.preIcoTitleLabel.isHidden = true
            self.preIcoTitleLabel.text = nil
            self.preIcoDateLabel.isHidden = true
            self.preIcoDateLabel.text = nil
        } else {
            self.preIcoTitleLabel.isHidden = false
            self.preIcoTitleLabel.text = "PRE"
            self.preIcoDateLabel.isHidden = false
            self.preIcoDateLabel.text = "\(preIcoStart ?? "") ~ \(preIcoEnd ?? "")"
        }
        if nil == icoStart, nil == icoEnd {
            self.icoTitleLabel.isHidden = true
            self.icoTitleLabel.text = nil
            self.icoDateLabel.isHidden = true
            self.icoDateLabel.text = nil
        } else {
            self.icoTitleLabel.isHidden = false
            self.icoTitleLabel.text = "ICO"
            self.icoDateLabel.isHidden = false
            self.icoDateLabel.text = "\(icoStart ?? "") ~ \(icoEnd ?? "")"
        }
        self.ratingLabel.text = "\(rating)"
    }
}
