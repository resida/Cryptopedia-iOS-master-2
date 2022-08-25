//
//  AllNewsListModel.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import PKHUD

class AllNewsListModel: NSObject {
    typealias didSelectRowAtIndex = ((_ tableView: UITableView, _ indexPath: IndexPath, _ aData: DatumCoinNews) -> ())?
    
    var didSelectRow: didSelectRowAtIndex = nil
    var errorOccured: ((String)->())? = nil
    
    var arrNews: [DatumCoinNews] = []
    
    override init() {
        super.init()
    }
}

extension AllNewsListModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailNewsCell.identifier) as! DetailNewsCell
        cell.setCoinNews = self.arrNews[indexPath.row]
        return cell
    }
}

extension AllNewsListModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectRow!(tableView, indexPath, self.arrNews[indexPath.row])
    }
}

