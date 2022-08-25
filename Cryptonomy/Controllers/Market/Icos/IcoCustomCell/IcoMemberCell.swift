//
//  IcoMemberCell.swift
//  ICOCO
//
//  Created by hsgu on 2018. 1. 30..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoMemberCell
class IcoMemberCell: UITableViewCell {
    // MARK: Static
    static let CellId = "IcoMemberCell"
    
    // MARK: Outlet
    @IBOutlet weak var profileImageView: PrImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2.0
    }
}

// MARK: - Function
extension IcoMemberCell {
    func setData(member: IcoTeam) {
        var title = member.title
        if let group = member.group, false == group.isEmpty {
            title?.append(" in \(group)")
        }
        self.profileImageView.setImageUrl(path: member.photo, placeHolder: nil)
        self.nameLabel.text = member.name
        self.titleLabel.text = title
    }
}
