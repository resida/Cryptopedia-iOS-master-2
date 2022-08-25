//
//  ViewController.swift
//  Cryptonomy
//
//

import UIKit
import SwiftWebVC
import FirebaseDatabase
import Kingfisher
import PopupDialog
import SwiftRater

class HomeVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSponsor: UIButton!
    
    //MARK:- Public Variables
    var coinNewsData: [DatumCoinNews] = []
    var homeHeaderView: HomeHeaderView?
    var currentSponsor: Sponsor!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }

    @objc func newsNotificationArrived(url: String) {
        if !url.isEmpty {
            self.openWebViewInApp(at: url)
            /*
             let webVC = SwiftModalWebVC(urlString: url)
             webVC.title = "News"
             self.navigationController?.present(webVC, animated: true, completion: nil)
             */
        } 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //AppDelegate.appDelegate().blueNavitationBarSettings(navController: self.navigationController!)
        let image = #imageLiteral(resourceName: "cryptopedialogo")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: image.size.width,
                                 height: image.size.height)
        self.navigationItem.titleView = imageView
        self.fetTopRecentNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        SwiftRater.check()
    }

    //MARK: - Common Init

    func commonInit() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(DetailNewsCell.nib, forCellReuseIdentifier: DetailNewsCell.identifier)
        self.tableView.register(HomeHeaderView.nib, forHeaderFooterViewReuseIdentifier: HomeHeaderView.identifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.bounces = false
        
        self.fetchMonthlySponsors()
    }
    
    //MARK: - Fetch Top Recent News
    
    func fetTopRecentNews() {
        apiMgr.getCoinNewsData(success: { coinDetail in
            DispatchQueue.main.async {
                self.coinNewsData = coinDetail
                self.tableView.reloadData()
            }
        }, failure: { message in
            Common.showAlert(Global.appName, message, self)
        })
    }
    
    //MARK: - Fetch Monthly Sponsors
    
    func fetchMonthlySponsors() {
        self.popupDialogAppearanceSettings()
        let ref = Database.database().reference()
        ref.child("monthlysponsors").observeSingleEvent(of: .value, with: { snapshot in
            let sponsor = Sponsor.exportSponsorFromSnapshot(snapshot)
            if sponsor.title == "" {
                self.tableBottomConstraint.constant = 0
            } else {
                self.currentSponsor = sponsor
                if let imageurl = sponsor.imageURL,let url = URL(string: imageurl) {
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, cachetype, url) in
                        guard let tmpImage = image else { return }
                        self.currentSponsor.image = tmpImage
                    }
                }
                self.showButton()
            }
        })
    }
    
    func showButton() {
        let message = self.currentSponsor.name! + " is our sponsor for the month of " + self.currentSponsor.month! + "."
        btnSponsor.setTitle(message, for: .normal)
        btnSponsor.titleLabel?.adjustsFontSizeToFitWidth = true
        btnSponsor.titleLabel?.minimumScaleFactor = 0.5
        btnSponsor.semanticContentAttribute = .forceRightToLeft
        btnSponsor.tintColor = UIColor.white
        btnSponsor.setTitleColor(UIColor.white, for: .normal)
        
        UIView.animate(withDuration: 0.25) { self.tableBottomConstraint.constant = self.btnSponsor.frame.size.height }
    }
    
    func popupDialogAppearanceSettings() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.messageFont = UIFont.circularBook(16.0)
        dialogAppearance.titleFont = UIFont.circularMedium(22.0)
        dialogAppearance.titleColor = UIColor.c_CommonDarkColor
        dialogAppearance.titleTextAlignment = .center
        dialogAppearance.messageTextAlignment = .center
        dialogAppearance.messageColor = UIColor.darkGray
        
        let buttonAppearance = PopupDialogButton.appearance()
        buttonAppearance.titleFont = UIFont.circularMedium(17.0)
        buttonAppearance.titleColor = UIColor.c_Blue
        
        let cancelAppearance = CancelButton.appearance()
        cancelAppearance.titleFont = UIFont.circularMedium(17.0)
        cancelAppearance.titleColor = UIColor.c_CommonDarkColor
    }
    
    fileprivate func showPopupDialog(withoutImage: Bool = false) {
        let sponsor = self.currentSponsor!
        let popup = PopupDialog(title: sponsor.title, message: sponsor.sDescription, image: withoutImage ? nil : sponsor.image, buttonAlignment: .vertical, transitionStyle: PopupDialogTransitionStyle.fadeIn, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false, completion: nil)
        let readMoreBtn = PopupDialogButton(title: "Read More", action: {
            if let remoteURL = sponsor.readMoreURL {
                self.openWebViewInApp(at: remoteURL)
            }
        })
        let otherSponserBtn = PopupDialogButton(title: "Other Sponsors", action: {
            if let otherURL = sponsor.otherSponsorURL {
                self.openWebViewInApp(at: otherURL)
            }
        })
        let cancelBtn = CancelButton(title: "Cancel", action: {
            popup.dismiss()
        })
        popup.addButtons([readMoreBtn, otherSponserBtn, cancelBtn])
        self.present(popup, animated: true, completion: nil)
    }
    
    func openDialogBox() {
        if let _ = self.currentSponsor.image {
            showPopupDialog()
        } else {
            if let imageurl = self.currentSponsor.imageURL,let url = URL(string: imageurl) {
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, cachetype, url) in
                    guard let tmpImage = image else {
                        self.showPopupDialog(withoutImage: true)
                        return
                    }
                    self.currentSponsor.image = tmpImage
                    self.showPopupDialog()
                }
            } else {
                self.showPopupDialog(withoutImage: true)
            }
        }
    }
    
    //MARK: - Update Header Data
    
    func updateHomeHeaderData() {
        if let view = self.homeHeaderView {
            view.fetTopHeaderData()
        } else {
            self.homeHeaderView?.isApiCalled = false
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Button tap events
    
    @IBAction func btnShowSponsorTapped(_ sender: Any) {
        self.openDialogBox()
    }

    @IBAction func btnTapToStartTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
}

extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.coinNewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailNewsCell.identifier) as! DetailNewsCell
            cell.setCoinNews = self.coinNewsData[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            self.homeHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeHeaderView.identifier) as? HomeHeaderView
            self.homeHeaderView?.didSelectCollectionItem = { (collectionView, indexPath, datum) in
                let marketDetailVC = UIStoryboard.marketDetailVC
                marketDetailVC.datum = datum
                self.navigationController?.pushViewController(marketDetailVC, animated: true)
            }
            self.homeHeaderView?.errorOccured = { message in
                Common.showAlert(Global.appName, message, self)
            }
            self.homeHeaderView?.btnTapToStart.addTarget(self, action: #selector(btnTapToStartTapped(_:)), for: .touchUpInside)
            
            return homeHeaderView
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
            view.backgroundColor = UIColor.white
            
            let label = UILabel(frame: CGRect(x: 15.0, y: 8, width: 100, height: 21))
            label.text = self.coinNewsData.count > 0 ? "News" : ""
            label.font = UIFont.circularMedium(16.0)
            label.textColor = .black
            view.addSubview(label)
            
            return view
        }
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let item = self.coinNewsData[indexPath.row]
            guard let url = item.url else {
                return
            }
            self.openWebViewInApp(at: url)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 181 : 30
    }
}
