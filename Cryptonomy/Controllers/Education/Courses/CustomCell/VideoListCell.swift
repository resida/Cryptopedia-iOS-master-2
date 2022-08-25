//
//  VideoListCell.swift
//  Cryptonomy
//

import UIKit
import Kingfisher

class VideoListCell: UITableViewCell {

    @IBOutlet var videoImgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var playIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.videoImgView.cornerRadius = 3.0
        self.videoImgView.layer.masksToBounds = true
    }

    var setVideo: Video! {
        didSet {
            if let image = setVideo.imageURL {
                let url = URL(string: image)
                self.videoImgView.kf.setImage(with: url)
            }
            self.lblTitle.text = setVideo.title ?? ""
            self.lblDescription.text = setVideo.vDescription ?? ""
        }
    }
}
