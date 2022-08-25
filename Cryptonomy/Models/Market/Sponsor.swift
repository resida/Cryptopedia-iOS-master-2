//
//  Sponsor.swift
//  Resources
//
//

import Foundation
import FirebaseDatabase

struct Sponsor {
    let title: String?
    let sDescription: String?
    let imageURL: String?
    let readMoreURL: String?
    let otherSponsorURL: String?
    let name: String?
    let month: String?
    var image: UIImage?
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as? [String: AnyObject] ?? [:]
        self.title = data["title"] as? String ?? ""
        self.sDescription = data["description"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        self.readMoreURL = data["readmoreurl"] as? String ?? ""
        self.otherSponsorURL = data["othersponsorurl"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.month = data["month"] as? String ?? ""
    }
    
    static func exportSponsorFromSnapshot(_ snapshot: DataSnapshot) -> Sponsor {
        return self.init(with: snapshot)
    }
}

