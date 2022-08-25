//
//  IcoProfileVC.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 25..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoProfileVC
class IcoProfileVC: UIViewController {
    struct ScrollViewContent {
        var tableView: UITableView? = nil
        var noContentsLabel: UILabel? = nil
    }
    
    // MARK: Outlet
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var ratingsTableView: UITableView!
    
    // MARK: Variable
    internal var model = IcoProfileModel()
    internal var indicator: UIActivityIndicatorView? = nil
    internal var scrollContents = Array<ScrollViewContent>() // 0: about, 1: teeam, 2: ratings
    internal var icoId: Int? = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(IcoProfileVC.pressedShareButton(_:)))
        self.navigationItem.rightBarButtonItems = [shareItem]
        self.segControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        self.initTableView(tableView: self.aboutTableView, cellIds: ["SimpleCell", "IcoSummaryCell", "IcoFinanceCell", "IcoMilestoneCell"])
        self.initTableView(tableView: self.teamTableView, cellIds: ["IcoMemberCell"])
        self.initTableView(tableView: self.ratingsTableView, cellIds: ["IcoRatingCell"])
        self.scrollView.delegate = self

        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        self.refreshData()
    }
}

// MARK: - Event
extension IcoProfileVC {
    @objc func pressedShareButton(_ sender: Any?) {
        if let urlStr = self.model.icoProfile?.links?.www, let url = URL(string: urlStr) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * self.scrollView.frame.width
        let offset = CGPoint(x: x, y: 0)
        self.scrollView.setContentOffset(offset, animated: true)
    }
}

// MARK: - Function
extension IcoProfileVC {
    func setData(icoId: Int) {
        self.icoId = icoId
    }
    
    internal func refreshData() {
        self.indicator?.startAnimating()
        if let icoId = self.icoId {
            self.model.getIcoProfile(icoId: icoId, success: {
                for scrollContent in self.scrollContents {
                    scrollContent.tableView?.reloadData()
                }
                self.indicator?.stopAnimating()
            }) { (errMsg) in
                self.indicator?.stopAnimating()
                MessageUtil.showAlert(targetVc: self, title: nil, message: "Can't load ICO profile.", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}

// UIScrollViewDelegate
extension IcoProfileVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let index = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
            self.segControl.selectedSegmentIndex = index
        }
    }
}
