//
//  PrImageView.swift
//  ICOCO
//
//  Created by hsgu on 2018. 1. 26..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - PrImageView
class PrImageView: UIImageView {
    internal static var cache = NSCache<NSString, AnyObject>()
    internal let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    deinit {
        self.dataTask?.cancel()
        self.dataTask = nil
    }
}

// MARK: - Function
extension PrImageView {
    func setImageUrl(path: String?, placeHolder: UIImage?) {
        weak var weakSelf = self
        weakSelf?.dataTask?.cancel()
        weakSelf?.dataTask = nil
        weakSelf?.image = nil
        
        guard let imagePath = path else {
            return
        }
        
        if nil != placeHolder {
            weakSelf?.image = placeHolder
        }
        
        DispatchQueue.global(qos: .background).async {
            if let cachedData = PrImageView.cache.object(forKey: imagePath as NSString) as? Data, let image = UIImage(data: cachedData) {
                DispatchQueue.main.async {
                    weakSelf?.image = image
                }
            } else if let url = URL(string: imagePath) {
                weakSelf?.dataTask = weakSelf?.urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let nsdata = data as NSData?, let image = UIImage(data: data!) {
                        PrImageView.cache.setObject(nsdata, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            weakSelf?.image = image
                        }
                    }
                })
                weakSelf?.dataTask?.resume()
            }
        }
    }
}
