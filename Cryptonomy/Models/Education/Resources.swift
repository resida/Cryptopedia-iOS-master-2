//
//  Resources.swift
//  Resources
//
//

import Foundation
import FirebaseDatabase

struct Resource {
    let title: String?
    var arrItems: [ResourceItem] = []
    
    init(with data: [String: AnyObject]) {
        self.title = data["title"] as? String ?? ""
        if let items = data["links"] as? [[String: AnyObject]] {
            for data in items {
                let item = ResourceItem.dataWithInfo(data)
                self.arrItems.append(item)
            }
        }
    }
    
    static func dataWithInfo(object: [String: AnyObject]) -> Resource {
        return self.init(with: object)
    }
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as! [String: AnyObject]
        self.title = data["title"] as? String ?? ""
        
        for child in snapshot.childSnapshot(forPath: "links").children {
            let myChild = child as! DataSnapshot
            let item = ResourceItem.exportItemFromSnapshot(myChild)
            self.arrItems.append(item)
        }
    }
    
    static func exportResourceFromSnapshot(_ snapshot: DataSnapshot) -> Resource {
        return self.init(with: snapshot)
    }
}


struct ResourceItem {
    let title: String?
    let imageURL: String?
    let url: String?
    
    init(with data: [String: AnyObject]) {
        self.title = data["title"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        self.url = data["url"] as? String ?? ""
    }
    
    static func dataWithInfo(_ data: [String: AnyObject]) -> ResourceItem {
        return self.init(with: data)
    }
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as! [String: AnyObject]
        self.title = data["title"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        self.url = data["url"] as? String ?? ""
    }
    
    static func exportItemFromSnapshot(_ snapshot: DataSnapshot) -> ResourceItem {
        return self.init(with: snapshot)
    }
}
