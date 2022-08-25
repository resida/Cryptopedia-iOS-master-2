//
//  IcoProfileVC+Table.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 29..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - UITableView
extension IcoProfileVC: UITableViewDataSource, UITableViewDelegate {
    // Function
    internal func initTableView(tableView: UITableView, cellIds: Array<String>) {
        var scrollContent = ScrollViewContent()
        
        // TableView
        let defaultCellId = "DefaultCell"
        scrollContent.tableView = tableView
        scrollContent.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellId)
        for cellId in cellIds {
            scrollContent.tableView?.register(UINib(nibName: cellId, bundle: Bundle.main), forCellReuseIdentifier: cellId)
        }
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
    
    internal func setAboutTableViewCell(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell? = nil
        if 0 == indexPath.row { // Summary
            let data = self.model.icoProfile
            var name = data?.name
            if let token = data?.finance?.token {
                name?.append(" (\(token))")
            }
            var desc = (data?.tagline ?? "") + "\n"
            if let country = data?.country {
                desc += "(" + country + ")"
            }
            let icoSummaryCell = self.aboutTableView.dequeueReusableCell(withIdentifier: IcoSummaryCell.CellId) as! IcoSummaryCell
            icoSummaryCell.setData(
                name: name, logo: data?.logo, desc: desc,
                dates: data?.dates, rating: data?.rating ?? 0,
                descFont: UIFont.circularBook(13)
            )
            cell = icoSummaryCell
        } else if 1 == indexPath.row { // Intro
            let intro = self.model.icoProfile?.intro
            let simpleCell = self.aboutTableView.dequeueReusableCell(withIdentifier: SimpleCell.CellId) as! SimpleCell
            simpleCell.setData(content: intro, showSeparator: true, font: UIFont.circularBook(15))
            cell = simpleCell
        } else if 2 == indexPath.row { // Finance
            let finance = self.model.icoProfile?.finance
            let financeCell = self.aboutTableView.dequeueReusableCell(withIdentifier: IcoFinanceCell.CellId) as! IcoFinanceCell
            financeCell.setData(finance: finance)
            cell = financeCell
        } else if 3 <= indexPath.row { // Milestone
            let index = indexPath.row - 3
            let milestone = self.model.icoProfile?.milestones?[index]
            let milestoneCell = self.aboutTableView.dequeueReusableCell(withIdentifier: IcoMilestoneCell.CellId) as! IcoMilestoneCell
            milestoneCell.setData(isLeft: (0 == index%2), title: milestone?.title, content: milestone?.content)
            cell = milestoneCell
        }
        
        return cell
    }
    
    internal func setTeamTableViewCell(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell? = nil
        let memberCell = self.teamTableView.dequeueReusableCell(withIdentifier: IcoMemberCell.CellId) as! IcoMemberCell
        if let member = self.model.icoProfile?.team?[indexPath.row] {
            memberCell.setData(member: member)
        }
        cell = memberCell
        
        return cell
    }
    
    internal func setRatingsTableViewCell(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell? = nil
        let ratingCell = self.ratingsTableView.dequeueReusableCell(withIdentifier: IcoRatingCell.CellId) as! IcoRatingCell
        if let rating = self.model.icoProfile?.ratings?[indexPath.row] {
            ratingCell.setData(rating: rating)
        }
        cell = ratingCell
        
        return cell
    }
    
    // Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if tableView === self.aboutTableView { // About
            rowCount = 3 + (self.model.icoProfile?.milestones?.count ?? 0)
            let scrollContent = self.scrollContents[0]
            self.updateNoContentsLabel(scrollContent: scrollContent, rowCount: rowCount)
        } else if tableView === self.teamTableView { // Team
            rowCount = (self.model.icoProfile?.team?.count ?? 0)
            let scrollContent = self.scrollContents[1]
            self.updateNoContentsLabel(scrollContent: scrollContent, rowCount: rowCount)
        } else if tableView === self.ratingsTableView { // Ratings
            rowCount = (self.model.icoProfile?.ratings?.count ?? 0)
            let scrollContent = self.scrollContents[2]
            self.updateNoContentsLabel(scrollContent: scrollContent, rowCount: rowCount)
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if tableView === self.aboutTableView { // About
            cell = self.setAboutTableViewCell(indexPath: indexPath)
        } else if tableView === self.teamTableView { // Team
            cell = self.setTeamTableViewCell(indexPath: indexPath)
        } else if tableView === self.ratingsTableView { // Ratings
            cell = self.setRatingsTableViewCell(indexPath: indexPath)
        }
        
        if nil == cell {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        }
        
        return cell
    }
}
