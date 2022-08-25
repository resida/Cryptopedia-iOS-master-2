//
//  HomeNewsListVC.swift
//  Cryptonomy
//
//

import UIKit
import SJSegmentedScrollView
import SwiftWebVC

class HomeNewsListVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblList: UITableView!

    //MARK:- Public Variables
    fileprivate var viewModel: HomeListModel!

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeOnce()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTopRecentNews(animated: false, completion: {
            self.tblList.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Initialize Once
    
    func initializeOnce() {
        viewModel = HomeListModel()
        viewModel.errorOccured = { message in
            Common.showAlert(Gloabal.appName, message, self)
        }
        viewModel.didSelectTableItem = { (tableView, indexPath, item) in
            guard let url = item.url else {
                return
            }
            let webVC = SwiftModalWebVC(urlString: url)
            webVC.title = "News"
            self.navigationController?.present(webVC, animated: true, completion: nil)
        }
        
        tblList.tableFooterView = UIView()
        tblList.register(DetailNewsCell.nib, forCellReuseIdentifier: DetailNewsCell.identifier)
        
        tblList.dataSource = viewModel
        tblList.delegate = viewModel
    }
}


extension HomeNewsListVC: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.tblList
    }
}

