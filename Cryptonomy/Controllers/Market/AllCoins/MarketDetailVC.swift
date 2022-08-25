//
//  MarketDetailVC.swift
//  Cryptonomy
//
//

import UIKit
import Charts
import SwiftWebVC
import SwiftyUserDefaults

class MarketDetailVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Public Variables
    var datum: Datum!
    var arrNews = [DatumCoinNews]()
    
    fileprivate let marketDetailModel = MarketDetailModel()
    
    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = datum.name
        
        initializeTableView()
        listModelInitialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rightBarButtonItemSettings()

        marketDetailModel.datum = self.datum
        marketDetailModel.fetchCoinSpecificNews(symbol: self.datum.symbol!) { coinNews in
            self.arrNews = coinNews
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        marketDetailModel.fetchDataFromFirebase {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - List Model Initialization
    
    func listModelInitialization() {
        marketDetailModel.didSelectRow = { (tableView, indexPath, aData) in
            guard let url = aData.url else { return }
            self.openWebViewInApp(at: url)
        }
        
        marketDetailModel.addPortfolioEvent = { datum in
            let makeTradeVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeTradeVC") as! MakeTradeVC
            makeTradeVC.datum = datum
            
            self.navigationController?.pushViewController(makeTradeVC, animated: true)
        }
        
        marketDetailModel.didTapOnMoreNews = {
            self.performSegue(withIdentifier: "showAllNewsVC", sender: nil)
        }
        
        marketDetailModel.didTapOnRedFlags = {
            self.performSegue(withIdentifier: "showRedFlagsVC", sender: nil)
        }
        
        marketDetailModel.errorOccured = { message in
            Common.showAlert("Oops", message, self)
        }
    }
    
    func initializeTableView() {
        tableView.dataSource = marketDetailModel
        tableView.delegate = marketDetailModel
        
        tableView.register(ChartView.nib, forHeaderFooterViewReuseIdentifier: ChartView.identifier)
        tableView.register(RedFlagsView.nib, forHeaderFooterViewReuseIdentifier: RedFlagsView.identifier)
        tableView.register(NewsFooterView.nib, forHeaderFooterViewReuseIdentifier: NewsFooterView.identifier)
        tableView.register(MarketDetailNewsCell.nib, forCellReuseIdentifier: MarketDetailNewsCell.identifier)
        tableView.register(DetailNewsCell.nib, forCellReuseIdentifier: DetailNewsCell.identifier)
        tableView.register(SocialStateView.nib, forHeaderFooterViewReuseIdentifier: SocialStateView.identifier)
    }
    
    func rightBarButtonItemSettings() {
        let favorite = checkForFavorites()
        
        let button = UIButton()
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "bookmark_selected"), for: .selected)
        button.isSelected = favorite
        button.addTarget(self, action: #selector(btnFavoriteTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }

    func checkForFavorites() -> Bool {
        return FavoriteManager.shared.arrFavorites.contains(self.datum)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllNewsVC" {
            let destination = segue.destination as! AllNewsVC
            destination.arrNews = self.arrNews
        } else if segue.identifier == "showRedFlagsVC" {
            let destination = segue.destination as! RedFlagsVC
            destination.arrRedFlags = marketDetailModel.arrRedFlags
        }
    }
    
    //MARK: - Button tap events
    
    @objc func btnFavoriteTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            FavoriteManager.shared.arrFavorites.append(self.datum)
        } else {
            let index = FavoriteManager.shared.arrFavorites.firstIndex(of: self.datum)
            if let currentIndex = index { FavoriteManager.shared.arrFavorites.remove(at: currentIndex) }
        }
        Defaults[.arrFavorites] = FavoriteManager.shared.arrFavorites
    }
}
