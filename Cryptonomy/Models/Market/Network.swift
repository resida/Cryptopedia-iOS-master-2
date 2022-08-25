//
//  Network.swift
//  Cryptonomy
//

import Foundation
import FirebaseDatabase

struct Network {
    var key: String? = ""
    var value: String? = ""
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
