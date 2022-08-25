//
//  IcoVC+Table.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 26..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - UITableView
extension IcoVC: UITableViewDataSource, UITableViewDelegate {
    // Function
    internal func initTableView(icoStatus: IcoStatus, tableView: UITableView) {
        var scrollContent = ScrollViewContent()
        scrollContent.icoStatus = icoStatus
        
        // ActivityIndicator
        let indicatorCenterX = tableView.frame.origin.x + (tableView.frame.width / 2.0)
        let indicatorCenterY = (tableView.frame.height / 2.0)
        scrollContent.indicator = UiUtil.makeActivityIndicator(parentView: self.scrollContentView)
        scrollContent.indicator?.center = CGPoint(x: indicatorCenterX, y: indicatorCenterY)
        
        // RefreshControl
        scrollContent.refreshControl = UIRefreshControl()
        scrollContent.refreshControl?.addTarget(self, action: #selector(IcoVC.refreshData(_:)), for: .valueChanged)
        
        // TableView
        let defaultCellId = "DefaultCell"
        let icoSummaryCellId = IcoSummaryCell.CellId
        scrollContent.tableView = tableView
        scrollContent.tableView?.refreshControl = scrollContent.refreshControl
        scrollContent.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellId)
        scrollContent.tableView?.register(UINib(nibName: icoSummaryCellId, bundle: Bundle.main), forCellReuseIdentifier: icoSummaryCellId)
        scrollContent.tableView?.dataSource = self
        scrollContent.tableView?.delegate = self
        
        // NoContentView
        scrollContent.noContentsLabel = UILabel()
        scrollContent.noContentsLabel?.center.x = (tableView.frame.width / 2.0)
        scrollContent.noContentsLabel?.frame.origin.y = 100.0
        scrollContent.tableView?.addSubview(scrollContent.noContentsLabel!)
        
        // Add to array
        self.scrollContents.append(scrollContent)
    }
    
    internal func updateNoContentsLabel(scrollContent: ScrollViewContent, rowCount: Int) {
        var message: String? = nil
        if false == NetStatusUtil.shared.canConnectToInternet() {
            message = "Can't connect to internet."
        } else if 0 == rowCount {
            message = "No contents."
        }
        
        if let tableView = scrollContent.tableView, nil != message {
            scrollContent.noContentsLabel?.text = message
            scrollContent.noContentsLabel?.sizeToFit()
            scrollContent.noContentsLabel?.center.x = (tableView.frame.width / 2.0)
            scrollContent.noContentsLabel?.isHidden = false
        } else {
            scrollContent.noContentsLabel?.isHidden = true
            scrollContent.noContentsLabel?.text = nil
        }
    }
    
    // Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if let index = self.scrollContents.firstIndex(where: { $0.tableView === tableView }) {
            let scrollContent = self.scrollContents[index]
            rowCount = self.model.getRowCount(status: scrollContent.icoStatus)
            self.updateNoContentsLabel(scrollContent: scrollContent, rowCount: rowCount)
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let index = self.scrollContents.firstIndex(where: { $0.tableView === tableView }) {
            let scrollContent = self.scrollContents[index]
            let data = self.model.getRowData(row: indexPath.row, status: scrollContent.icoStatus)
            let icoSummaryCell = scrollContent.tableView!.dequeueReusableCell(withIdentifier: IcoSummaryCell.CellId) as! IcoSummaryCell
            icoSummaryCell.setData(
                name: data?.name, logo: data?.logo, desc: data?.desc,
                dates: data?.dates, rating: data?.rating ?? 0
            )
            cell = icoSummaryCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = self.scrollContents.firstIndex(where: { $0.tableView === tableView }) {
            let scrollContent = self.scrollContents[index]
            if (false == scrollContent.indicator?.isAnimating),
                (true == self.model.isMorePage(status: scrollContent.icoStatus)),
                (indexPath.row == self.model.getRowCount(status: scrollContent.icoStatus) - 1),
                 (true == NetStatusUtil.shared.canConnectToInternet())
            {
                self.getNextIcoListPage(status: scrollContent.icoStatus)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "IcoVC to IcoProfileVC", sender: tableView)
    }
}
