//
//  MarketDetailNewsCell.swift
//  Cryptonomy
//
//

import UIKit
import Kingfisher

class MarketDetailNewsCell: UITableViewCell {
    @IBOutlet weak var lblNewsTitle: UILabel!
    @IBOutlet weak var lblNewsDescription: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgNews.addCornerRadiusToView(3.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var setCoinNews: DatumCoinNews! {
        didSet {
            lblNewsTitle.attributedText =  NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 5.0, text: setCoinNews.title!, font: UIFont.circularMedium(15.0), fontColor: UIColor.c_CommonDarkColor)
            lblNewsDescription.attributedText = NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 3.0, text: setCoinNews.body!, font: UIFont.circularBook(13.0), fontColor: UIColor.c_CommonLightColor)
            
            if let image = setCoinNews.imageurl {
                let url = URL(string: image)
                imgNews.kf.setImage(with: url)
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval(setCoinNews.publishedOn))
            lblTimeAgo.text = setCoinNews.sourceInfo.name ?? "" + " - " + date.timeAgoSinceDate(numericDates: false)
        }
    }
}
