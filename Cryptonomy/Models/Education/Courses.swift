//
//  Courses.swift
//  Cryptonomy
//
//

import Foundation
import FirebaseDatabase

struct Courses {
    let title: String
    let cDescription: String
    let imageURL: String?
    var arrVideos: [Video] = []

    init(with data: [String: AnyObject]) {
        self.title = data["title"] as? String ?? ""
        self.cDescription = data["description"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        
        if let items = data["videos"] as? [[String: AnyObject]] {
            for data in items {
                let item = Video.dataWithInfo(object: data)
                self.arrVideos.append(item)
            }
        }
    }
    
    static func dataWithInfo(object: [String: AnyObject]) -> Courses {
        return self.init(with: object)
    }
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as! [String: AnyObject]
        self.title = data["title"] as? String ?? ""
        self.cDescription = data["description"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        
        for child in snapshot.childSnapshot(forPath: "videos").children {
            let myChild = child as! DataSnapshot
            let video = Video.exportVideoFromSnapshot(myChild)
            self.arrVideos.append(video)
        }
    }
    
    static func exportCoursesFromSnapshot(_ snapshot: DataSnapshot) -> Courses {
        return self.init(with: snapshot)
    }
}

struct Video {
    let title: String?
    let vDescription: String?
    let imageURL: String?
    let videoURL: String?
    
    init(with data: [String: AnyObject]) {
        self.title = data["title"] as? String ?? ""
        self.vDescription = data["description"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        self.videoURL = data["videourl"] as? String ?? ""
    }
    
    static func dataWithInfo(object: [String: AnyObject]) -> Video {
        return self.init(with: object)
    }
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as! [String: AnyObject]
        self.title = data["title"] as? String ?? ""
        self.vDescription = data["description"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
        self.videoURL = data["videourl"] as? String ?? ""
    }
    
    static func exportVideoFromSnapshot(_ snapshot: DataSnapshot) -> Video {
        return self.init(with: snapshot)
    }
}
