//
//  MarketListVC.swift
//  Cryptonomy
//


import UIKit

class MarketListVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Public Variables
    fileprivate let marketListModel = MarketListModel()
    private let refreshControl = UIRefreshControl()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeOnce()
        listModelInitialization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reloadTableData()
    }
    
    // MARK: - Navigatio@objc n
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datum = sender as? Datum else { return }
        
        if segue.identifier == "showMarketDetailVC" {
            let destination = segue.destination as! MarketDetailVC
            destination.datum = datum
        }
    }
    
    //MARK: - Initialize Once
    
    func initializeOnce() {
        tableView.dataSource = marketListModel
        tableView.delegate = marketListModel
        
        tableView.register(MarketListHeaderView.nib, forHeaderFooterViewReuseIdentifier: MarketListHeaderView.identifier)
        tableView.register(MarketListCell.nib, forCellReuseIdentifier: MarketListCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func textEmpty(_ text: String?) -> Bool {
        return ((text?.isEmpty)! || (text?.trim().isEmpty)!)
    }
    
    func searchUsingData(_ searchText: String) {
        let cellModels = MarketList.shared.listResponse?.data
        if textEmpty(searchText) == true {
            marketListModel.cellViewModels = cellModels ?? []
        } else {
            let filteredModels = cellModels?.filter { ($0.name?.lowercased().contains(searchText.lowercased()))!
                || ($0.symbol?.lowercased().contains(searchText.lowercased()))! }
            marketListModel.cellViewModels = filteredModels!
        }
        self.tableView.reloadData()
    }

    func updateDataAccordingToSearch() {
        self.checkForUpdates { (success, text) in
            if success == true {
                let cellModels = MarketList.shared.listResponse?.data
                let filteredModels = cellModels?.filter { ($0.name?.lowercased().contains(text!.lowercased()))!
                    || ($0.symbol?.lowercased().contains(text!.lowercased()))! }
                self.marketListModel.cellViewModels = filteredModels!
            }
        }
    }
    
    func checkForUpdates(completion: ((Bool, String?)->()))   {
        let topMarketVC = self.parent?.parent as! MarketVC
        if let text = topMarketVC.searchBar.text {
            if self.textEmpty(text) == false { completion(true, text) } else { completion(false, "") }
        } else {
            completion(false, "")
        }
    }
    
    //MARK: - List Model Initialization
    
    func listModelInitialization() {
        marketListModel.didSelectItem = { (tableView, indexPath, datum) in
            self.performSegue(withIdentifier: "showMarketDetailVC", sender: datum)
        }
        marketListModel.reloadTableViewClosure = {
            DispatchQueue.main.async {
                self.updateDataAccordingToSearch()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        marketListModel.errorOccured = { message in
            Common.showAlert("Oops", message, self)
            self.refreshControl.endRefreshing()
        }
        //marketListModel.fetchCoinMarketCapDataPro()
        //marketListModel.fetchCoinListFromCoinMarketCap(showLoading: true)
    }

    //MARK: - Refresh Control
    
    @objc func refreshData() {
        self.refreshControl.beginRefreshing()
        if MarketList.shared.shouldCallWebAPITimeStamp() {
            marketListModel.fetchCoinMarketCapDataPro(showLoading: false)
        } else {
            self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 1.0)
        }
    }
    
    func reloadTableData() {
        if MarketList.shared.shouldCallWebAPITimeStamp() {
            marketListModel.fetchCoinMarketCapDataPro(showLoading: false)
        } else {
            if let data = MarketList.shared.listResponse?.data {
                self.checkForUpdates { (success, text) in
                    if success == true {
                        self.updateDataAccordingToSearch()
                    } else {
                        marketListModel.cellViewModels = data
                    }
                }
            }
            self.tableView?.reloadData()
        }
    }
    
    func updateDataFromCurrencty() {
        marketListModel.resetData()
        marketListModel.fetchCoinMarketCapDataPro(showLoading: true)        
    }    
}
