//
//  AllBNewsVC.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import UIKit
import SwiftWebVC

class AllNewsVC: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Public Variables
    
    fileprivate let allNewsListModel = AllNewsListModel()
    var arrNews = [DatumCoinNews]()
    
    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeOnce()
        listModelInitialization()
    }
    
    //MARK: - Initialize Once
    
    func initializeOnce() {
        self.title = "News"
        
        tableView.dataSource = allNewsListModel
        tableView.delegate = allNewsListModel
        
        tableView.register(DetailNewsCell.nib, forCellReuseIdentifier: DetailNewsCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: - List Model Initialization
    
    func listModelInitialization() {
        allNewsListModel.didSelectRow = { (tableView, indexPath, aData) in
            guard let url = aData.url else {
                return
            }
            self.openWebViewInApp(at: url)
        }
        
        allNewsListModel.errorOccured = { message in
            Common.showAlert("Oops", message, self)
        }
        
        allNewsListModel.arrNews = self.arrNews
    }
}
