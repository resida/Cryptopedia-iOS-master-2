//
//  CourseHeaderView.swift
//  Resources
//
//

import UIKit

class CourseHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var btnCorporateEducation: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font = UIFont.circularMedium(20.0)
    }
}
