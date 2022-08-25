//
//  CoursesCell.swift
//  Cryptonomy
//
//

import UIKit
import Kingfisher

class CoursesCell: UITableViewCell {
    @IBOutlet var courseImgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.courseImgView.layer.cornerRadius = 4.0
        self.courseImgView.layer.masksToBounds = true
    }

    var setCourses: Courses! {
        didSet {
            lblTitle.attributedText =  NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 8.0, text: setCourses.title, font: UIFont.circularMedium(15.0), fontColor: UIColor.c_CommonDarkColor)
            lblDescription.attributedText = NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 3.0, text: setCourses.cDescription, font: UIFont.circularBook(13.0), fontColor: UIColor.c_CommonLightColor)
            
            if let image = setCourses.imageURL {
                let url = URL(string: image)
                courseImgView.kf.setImage(with: url)
            }
        }
    }
}
