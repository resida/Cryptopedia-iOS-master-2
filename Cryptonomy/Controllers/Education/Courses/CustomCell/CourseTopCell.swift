//
//  CourseTopCell.swift
//  Resources
//
//

import UIKit
import SwiftyShadow

class CourseTopCell: UITableViewCell {

    @IBOutlet weak var mainView: SwiftyInnerShadowView!
    @IBOutlet weak var courseImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.mainView.layer.cornerRadius = 6
        self.mainView.layer.masksToBounds = true
        
        self.mainView.layer.shadowRadius = 3
        self.mainView.layer.shadowOpacity = 0.4
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowOffset = CGSize.zero
        self.mainView.generateOuterShadow()
        
        self.selectionStyle = .none
        
        self.lblTitle.font =  UIFont.circularMedium(12.0)
    }
    
    func configureCourse(of course: Courses) {
        if let url = course.imageURL {
            self.courseImgView.kf.setImage(with: URL(string: url))
        }
    }
}
