//
//  FavoritesVC.swift
//  Cryptonomy
//
//

import UIKit

class FavoritesVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNoData: UILabel!
    
    //MARK: - Public Variables
    fileprivate let marketListModel = MarketListModel()
    private let refreshControl = UIRefreshControl()

    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeOnce()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblNoData.isHidden = FavoriteManager.shared.arrFavorites.count != 0
        if FavoriteManager.shared.arrFavorites.count != 0 {
            marketListModel.fetchFavoritesData {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datum = sender as? Datum else { return }
        
        if segue.identifier == "showMarketDetailVC" {
            let destination = segue.destination as! MarketDetailVC
            destination.datum = datum
        }
    }
    
    //MARK: - Initialize Once

    func initializeOnce() {        
        marketListModel.reloadTableViewClosure = {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        marketListModel.errorOccured = { message in
            Common.showAlert("Oops", message, self)
            self.refreshControl.endRefreshing()
        }

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MarketListHeaderView.nib, forHeaderFooterViewReuseIdentifier: MarketListHeaderView.identifier)
        tableView.register(MarketListCell.nib, forCellReuseIdentifier: MarketListCell.identifier)
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func updateDataFromCurrency() {
        marketListModel.resetData()
        marketListModel.fetchCoinMarketCapDataPro(showLoading: true)
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
}

extension FavoritesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteManager.shared.arrFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketListCell.identifier) as! MarketListCell
        let currentTicker = FavoriteManager.shared.arrFavorites[indexPath.row]
        cell.setMarketListTicker(ticker: currentTicker, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MarketListHeaderView.identifier)
        
        return view
    }
}

extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailVC") as! MarketDetailVC
        detailVC.datum = FavoriteManager.shared.arrFavorites[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FavoriteManager.shared.arrFavorites.isEmpty ? 0 : 50
    }
}
