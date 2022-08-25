//
//  CourseOtherCell.swift
//  Resources
//
//

import UIKit
import SwiftyShadow

class CourseOtherCell: UITableViewCell {

    @IBOutlet weak var courseImgview: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet var playIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.courseImgview?.layer.cornerRadius = 6
        self.courseImgview?.layer.masksToBounds = true        
        self.courseImgview?.layer.shadowRadius = 3
        self.courseImgview?.layer.shadowOpacity = 0.4
        self.courseImgview?.layer.shadowColor = UIColor.black.cgColor
        self.courseImgview?.layer.shadowOffset = CGSize.zero
        self.courseImgview?.generateOuterShadow()
        self.courseImgview?.contentMode = .scaleAspectFill
        
        self.selectionStyle = .none
        
        self.lblTitle.font =  UIFont.circularMedium(17.0)
        self.lblDesc.font = UIFont.circularBook(15.0)
    }
    
    func configureCourse(of course: Courses) {
        self.lblTitle.text = course.title
        self.lblDesc.text = course.cDescription
        if let url = course.imageURL {
            self.courseImgview.kf.setImage(with: URL(string: url))
        }
    }
    
    func configureVideo(of video: Video) {
        self.lblTitle.text = video.title
        self.lblDesc.text = video.vDescription
        if let url = video.imageURL {
            self.courseImgview.kf.setImage(with: URL(string: url))
        }
    }
}
