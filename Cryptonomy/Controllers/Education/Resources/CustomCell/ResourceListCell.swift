//
//  ResourceListCell.swift
//  Resources
//

import UIKit
import Kingfisher

class ResourceListCell: UITableViewCell {
    
    @IBOutlet weak var resourceImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.resourceImgView.layer.masksToBounds = true
        self.resourceImgView.layer.cornerRadius = 4.0
        self.resourceImgView.contentMode = .scaleAspectFit
        
        self.lblTitle.font = UIFont.circularBook(16.0)
    }
    
    func configureResource(of item: ResourceItem) {
        self.lblTitle.text = item.title
        if let url = item.imageURL {
            self.resourceImgView.kf.setImage(with: URL(string: url))
        }
    }
}
