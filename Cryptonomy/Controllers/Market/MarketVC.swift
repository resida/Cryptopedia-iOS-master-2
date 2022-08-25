//
//  MarketVC.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults

enum ViewStatus: Int {
    case titleEnabled = 1
    case searchEnabled = 2
}

class MarketVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK:- Public Variables
    var marketListController : MarketListVC!
    var favoriteListController : FavoritesVC!
    var pageMenu: CAPSPageMenu?
    
    var leftCurrencyBarItem: UIBarButtonItem? = nil
    var rightSearchBarItem: UIBarButtonItem? = nil
    var viewStatus: ViewStatus! {
        didSet {
            self.updateNavigationItems()
        }
    }

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeOnce()
        self.pageMenuInitialization()        
        self.viewStatus = .titleEnabled
    }

    //MARK: - Initialize Once
    
    func initializeOnce() {
        self.title = "Markets"
    }
    
    func updateNavigationItems() {
        if viewStatus == .searchEnabled {
            self.resetBarButtonItems()
        } else {
            self.initializeBarButtonItems()
        }
    }
    
    func initializeBarButtonItems() {
        self.initializeLeftItem()
        self.initializeRightItem()
        
        self.title = "Markets"
        self.navigationItem.titleView = nil
        self.searchBar.resignFirstResponder()
    }

    func initializeLeftItem() {
        self.leftCurrencyBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dollar"), style: .plain, target: self, action: #selector(btnCurrencyTapped(_:)))
        self.navigationItem.leftBarButtonItem = self.leftCurrencyBarItem
    }
    
    func initializeRightItem() {
        self.rightSearchBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_search_black_24pt"), style: .plain, target: self, action: #selector(btnSearchTapped(_:)))
        self.navigationItem.rightBarButtonItem = self.rightSearchBarItem
    }
    
    func resetBarButtonItems() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        self.navigationItem.titleView = self.searchBar
        if #available(iOS 11.0, *) {
            self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        self.searchBar.text = ""
        self.searchBar.becomeFirstResponder()
    }

    //MARK: - Page Menu Initialization
    
    func pageMenuInitialization() {
        var controllerArray: [UIViewController] = []
            
        marketListController = UIStoryboard.marketListVC
        marketListController.title = "All Coins"
        
        controllerArray.append(marketListController)
        
        let controller2 = UIStoryboard.icoVC
        controller2.title = "ICOs"
        controllerArray.append(controller2)
        
        favoriteListController = UIStoryboard.favoritesVC
        favoriteListController.title = "Favorites"
        controllerArray.append(favoriteListController)
        
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(true),
            .menuItemFont(UIFont.circularMedium(16.0)),
            .selectedMenuItemLabelColor(UIColor.c_Blue),
            .unselectedMenuItemLabelColor(UIColor.c_PageMenuDefaultColor),
            .addBottomMenuHairline(false),
            .centerMenuItems(true),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .menuItemSeparatorColor(UIColor.white),
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height),
                                pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        self.addChild(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParent: self)
    }
    
    //MARK: - Button tap events
    
    @IBAction func btnCurrencyTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
        for item in Currency.shared.arrSymbols {
            let action = UIAlertAction(title: item, style: .default) { action in
                Defaults[.currentCurrency] = action.title!
                
                if self.pageMenu?.currentPageIndex == 0 || self.pageMenu?.currentPageIndex == 1 {
                    self.marketListController.updateDataFromCurrencty()
                } else if self.pageMenu?.currentPageIndex == 2 {
                    self.favoriteListController.updateDataFromCurrency()
                }
            }
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        self.viewStatus = .searchEnabled
    }
}

extension MarketVC : CAPSPageMenuDelegate {
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        if index == 0 {
            self.initializeBarButtonItems()
        }
    }
}

extension MarketVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewStatus = .titleEnabled
        self.searchBar.text = ""
        marketListController.searchUsingData("")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        marketListController.searchUsingData(searchText)
    }
}
