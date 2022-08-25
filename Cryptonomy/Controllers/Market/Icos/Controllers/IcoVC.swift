//
//  IcoVC.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - IcoVC
class IcoVC: UIViewController {
    struct ScrollViewContent {
        var icoStatus: IcoStatus = .none
        var indicator: UIActivityIndicatorView? = nil
        var refreshControl: UIRefreshControl? = nil
        var tableView: UITableView? = nil
        var noContentsLabel: UILabel? = nil
    }
    
    // MARK: Outlet
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var ongoingTableView: UITableView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var endedTableView: UITableView!
    
    // MARK: Variable
    internal var model = IcoModel()
    internal var scrollContents = Array<ScrollViewContent>() // 0: ongoing, 1: upcoming, 2: ended
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        self.scrollView.delegate = self
        
        self.initTableView(icoStatus: .ongoing, tableView: self.ongoingTableView)
        self.initTableView(icoStatus: .upcoming, tableView: self.upcomingTableView)
        self.initTableView(icoStatus: .ended, tableView: self.endedTableView)
        
        self.getFirstIcoListPage(status: .ongoing)
        self.getFirstIcoListPage(status: .upcoming)
        self.getFirstIcoListPage(status: .ended)
    }
}

// MARK: - Event
extension IcoVC {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * self.scrollView.frame.width
        let offset = CGPoint(x: x, y: 0)
        self.scrollView.setContentOffset(offset, animated: true)
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        if sender == self.scrollContents[0].refreshControl {
            self.getFirstIcoListPage(status: .ongoing)
        } else if sender == self.scrollContents[1].refreshControl {
            self.getFirstIcoListPage(status: .upcoming)
        } else if sender == self.scrollContents[2].refreshControl {
            self.getFirstIcoListPage(status: .ended)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let icoProfileVC = segue.destination as? IcoProfileVC {
            if let scrollContent = self.scrollContents.filter({ $0.tableView == sender as? UITableView }).first {
                if let indexPath = scrollContent.tableView?.indexPathForSelectedRow,
                    let data = self.model.getRowData(row: indexPath.row, status: scrollContent.icoStatus)
                {
                    icoProfileVC.title = data.name
                    icoProfileVC.setData(icoId: data.id)
                }
            }
        }
    }
}

// MARK: - Function
extension IcoVC {
    internal func getFirstIcoListPage(status: IcoStatus) {
        if let scrollContent = self.scrollContents.filter({ $0.icoStatus == status }).first {
            scrollContent.indicator?.startAnimating()
            self.model.getFirstIcoListPage(status: scrollContent.icoStatus, success: { (icoStatus) in
                scrollContent.tableView?.reloadData()
                scrollContent.refreshControl?.endRefreshing()
                scrollContent.indicator?.stopAnimating()
            }) { (errMsg) in
                scrollContent.indicator?.stopAnimating()
                if nil != errMsg {
                    MessageUtil.showAlert(targetVc: self, title: nil, message: errMsg, completion: {
                        scrollContent.refreshControl?.endRefreshing()
                    })
                } else {
                    scrollContent.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    internal func getNextIcoListPage(status: IcoStatus) {
        if let scrollContent = self.scrollContents.filter({ $0.icoStatus == status }).first {
            scrollContent.indicator?.startAnimating()
            self.model.getNextIcoListPage(status: scrollContent.icoStatus, success: { (icoStatus) in
                scrollContent.tableView?.reloadData()
                scrollContent.refreshControl?.endRefreshing()
                scrollContent.indicator?.stopAnimating()
            }) { (errMsg) in
                scrollContent.indicator?.stopAnimating()
                if nil != errMsg {
                    MessageUtil.showAlert(targetVc: self, title: nil, message: errMsg, completion: {
                        scrollContent.refreshControl?.endRefreshing()
                    })
                } else {
                    scrollContent.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

extension IcoVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let index = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
            self.segControl.selectedSegmentIndex = index
        }
    }
}
