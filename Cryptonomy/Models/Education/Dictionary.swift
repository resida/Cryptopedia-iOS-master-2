//
//  Dictionary.swift
//  Cryptonomy
//
//

import Foundation
import FirebaseDatabase

struct DictResponse {
    let key: String
    let data: DictData
    
    init(key: String, data: DictData) {
        self.key = key
        self.data = data
    }
    
    init(with snapshot: DataSnapshot) {
        let data = snapshot.value as! [String: AnyObject]
        self.key = snapshot.key
        self.data = DictData.init(data: data)
    }
    
    static func exportDictFromSnapshot(_ snapshot: DataSnapshot) -> DictResponse {
        return self.init(with: snapshot)
    }
}

struct DictData {
    let definations: String?
    let term: String?
    let youtubeLink: String?
    
    init(data: [String: AnyObject]) {
        self.definations = data["definitions"] as? String ?? ""
        self.term = data["term"] as? String ?? ""
        self.youtubeLink = data["youtubeLink"] as? String
    }
    
    init(defination: String, term: String, youtubeLink: String) {
        self.definations = defination
        self.term = term
        self.youtubeLink = youtubeLink
    }
}
