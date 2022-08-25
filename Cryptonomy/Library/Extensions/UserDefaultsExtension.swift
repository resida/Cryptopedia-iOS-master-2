//
//  UserDefaultsExtension.swift
//  Cryptonomy
//
//

import Foundation
import  SwiftyUserDefaults

extension UserDefaults {
    subscript<T: Codable>(key: DefaultsKey<T?>) -> T? {
        get {
            guard let data = object(forKey: key._key) as? Data else { return nil }
            
            let decoder = JSONDecoder()
            let dictionary = try! decoder.decode([String: T].self, from: data)
            return dictionary["top"]
        }
        set {
            guard let value = newValue else { return set(nil, forKey: key._key) }
            
            let encoder = JSONEncoder()
            let data = try! encoder.encode(["top": value])
            set(data, forKey: key._key)
        }
    }
}

