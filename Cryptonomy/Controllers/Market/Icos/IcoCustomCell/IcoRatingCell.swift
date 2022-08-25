//
//  IcoRatingCell.swift
//  ICOCO
//
//  Created by hsgu on 2018. 1. 30..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoRatingCell
class IcoRatingCell: UITableViewCell {
    // MARK: Static
    static let CellId = "IcoRatingCell"
    
    // MARK: Outlet
    @IBOutlet weak var profileImageView: PrImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var teamRatingView: UIView!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var visionRatingView: UIView!
    @IBOutlet weak var visionRatingLabel: UILabel!
    @IBOutlet weak var productRatingView: UIView!
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var profileRatingView: UIView!
    @IBOutlet weak var profileRatingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: Lifeccle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2.0
        self.weightLabel.layer.cornerRadius = 3.0
        self.agreeLabel.layer.cornerRadius = 3.0
        self.teamRatingLabel.layer.cornerRadius = self.teamRatingLabel.frame.width / 2.0
        self.visionRatingLabel.layer.cornerRadius = self.visionRatingLabel.frame.width / 2.0
        self.productRatingLabel.layer.cornerRadius = self.productRatingLabel.frame.width / 2.0
        self.profileRatingLabel.layer.cornerRadius = self.profileRatingLabel.frame.width / 2.0
    }
}

// MARK: - Function
extension IcoRatingCell {
    func setData(rating: IcoRating) {
        self.profileImageView.setImageUrl(path: rating.photo, placeHolder: nil)
        self.nameLabel.text = rating.name
        self.titleLabel.text = rating.title
        self.dateLabel.text = rating.date
        self.weightLabel.text = "Weight " + (rating.weight ?? "0%")
        self.agreeLabel.text = "Agree \(rating.agree)"
        self.teamRatingLabel.text = "\(rating.team)"
        self.visionRatingLabel.text = "\(rating.vision)"
        self.productRatingLabel.text = "\(rating.product)"
        self.profileRatingLabel.text = "\(rating.profile)"
        if 0 < rating.profile {
            self.teamRatingView.isHidden = true
            self.visionRatingView.isHidden = true
            self.productRatingView.isHidden = true
            self.profileRatingView.isHidden = false
        } else {
            self.teamRatingView.isHidden = false
            self.visionRatingView.isHidden = false
            self.productRatingView.isHidden = false
            self.profileRatingView.isHidden = true
        }
        self.reviewLabel.text = rating.review
    }
}
