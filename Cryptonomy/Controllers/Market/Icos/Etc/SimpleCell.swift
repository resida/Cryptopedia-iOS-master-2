//
//  SimpleCell.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 27..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - SimpleCell
class SimpleCell: UITableViewCell {
    // MARK: Constant
    static let CellId = "SimpleCell"
    
    // MARK: Outlet
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Function
extension SimpleCell {
    func setData(content: String?, showSeparator: Bool, font: UIFont? = nil) {
        self.contentLabel.text = content
        self.contentLabel.font = font
        self.separator.isHidden = !showSeparator
    }
}
