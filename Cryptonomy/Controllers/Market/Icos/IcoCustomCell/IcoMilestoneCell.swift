//
//  IcoMilestoneCell.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 29..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoMilestoneCell
class IcoMilestoneCell: UITableViewCell {
    // MARK: Static
    static let CellId = "IcoMilestoneCell"
    
    // MARK: Outlet
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftContentLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightContentLabel: UILabel!
    @IBOutlet weak var dotView: UIView!

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dotView.layer.cornerRadius = self.dotView.frame.width / 2.0
    }
}

// MARK: - Function
extension IcoMilestoneCell {
    func setData(isLeft: Bool, title: String?, content: String?) {
        if true == isLeft {
            self.leftTitleLabel.text = title
            self.leftTitleLabel.isHidden = false
            self.leftContentLabel.text = content
            self.leftContentLabel.isHidden = false
            self.rightTitleLabel.text = nil
            self.rightTitleLabel.isHidden = true
            self.rightContentLabel.text = nil
            self.rightContentLabel.isHidden = true
        } else {
            self.leftTitleLabel.text = nil
            self.leftTitleLabel.isHidden = true
            self.leftContentLabel.text = nil
            self.leftContentLabel.isHidden = true
            self.rightTitleLabel.text = title
            self.rightTitleLabel.isHidden = false
            self.rightContentLabel.text = content
            self.rightContentLabel.isHidden = false
        }
    }
}
