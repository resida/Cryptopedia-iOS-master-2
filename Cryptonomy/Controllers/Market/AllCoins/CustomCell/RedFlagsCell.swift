//
//  RedFlagsCell.swift
//  Cryptonomy
//
//

import UIKit

class RedFlagsCell: UITableViewCell {

    @IBOutlet var lblNo: UILabel!
    @IBOutlet var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblNo.textColor = UIColor.c_CommonDarkColor
        self.lblText.textColor = UIColor.c_CommonDarkColor
        
        self.lblText.font = UIFont.circularBook(14.0)
        self.lblNo.font = UIFont.circularBook(14.0)
    }
}
