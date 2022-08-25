//
//  IcoModel.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation

// MARK: - IcoModel
class IcoModel {
    struct SummaryList {
        var status: IcoStatus = .none
        var icos: Int = 0
        var pages: Int = 0
        var currentPage: Int = 0
        var noMorePage = false
        var icoSummaries = Array<IcoSummary>()
    }
    
    internal let request = PrHttpRequest()
    internal var summaryLists = Array<SummaryList>()
    
    init() {
        var ongoing = SummaryList()
        ongoing.status = .ongoing
        self.summaryLists.append(ongoing)
        
        var upcoming = SummaryList()
        upcoming.status = .upcoming
        self.summaryLists.append(upcoming)
        
        var ended = SummaryList()
        ended.status = .ended
        self.summaryLists.append(ended)
    }
}

// MARK: - Function
extension IcoModel {
    func isMorePage(status: IcoStatus) -> Bool {
        var morePage = false
        if let summaryList = self.summaryLists.filter({ $0.status == status }).first {
            morePage = !summaryList.noMorePage
        }
        return morePage
    }
    
    // Row
    func getRowCount(status: IcoStatus) -> Int {
        var count = 0
        if let summaryList = self.summaryLists.filter({ $0.status == status }).first {
            count = summaryList.icoSummaries.count
        }
        return count
    }
    
    func getRowData(row: Int, status: IcoStatus) -> IcoSummary? {
        var summary: IcoSummary? = nil
        if let summaryList = self.summaryLists.filter({ $0.status == status }).first {
            summary = summaryList.icoSummaries[row]
        }
        return summary
    }
}

// MARK: - Request
extension IcoModel {
    func getFirstIcoListPage(status: IcoStatus, success: ((IcoStatus) -> Void)?, failure: ((String?) -> Void)?) {
        if let index = self.summaryLists.firstIndex(where: { $0.status == status }) {
            let page = 0
            self.summaryLists[index].noMorePage = false
            self.request.getIcoList(status: status.rawValue, page: page, success: { (statusCode, icoSummaryList) in
                self.summaryLists[index].icoSummaries.removeAll()
                if let responseObject = icoSummaryList {
                    self.summaryLists[index].icos = responseObject.icos
                    self.summaryLists[index].pages = responseObject.pages
                    self.summaryLists[index].currentPage = responseObject.currentPage
                    if let results = responseObject.results, 0 < results.count {
                        self.summaryLists[index].icoSummaries.append(contentsOf: results)
                    } else {
                        self.summaryLists[index].noMorePage = true
                    }
                } else {
                    self.summaryLists[index].icos = 0
                    self.summaryLists[index].pages = 0
                    self.summaryLists[index].currentPage = 0
                    self.summaryLists[index].noMorePage = true
                }
                success?(status)
            }) { (statusCode, errMsg) in
                failure?(errMsg)
            }
        } else {
            failure?("App: Access failed.")
        }
    }
    
    func getNextIcoListPage(status: IcoStatus, success: ((IcoStatus) -> Void)?, failure: ((String?) -> Void)?) {
        if let index = self.summaryLists.firstIndex(where: { $0.status == status }) {
            let page = self.summaryLists[index].currentPage + 1
            self.request.getIcoList(status: status.rawValue, page: page, success: { (statusCode, icoSummaryList) in
                if let responseObject = icoSummaryList {
                    self.summaryLists[index].icos = responseObject.icos
                    self.summaryLists[index].pages = responseObject.pages
                    self.summaryLists[index].currentPage = responseObject.currentPage
                    if let results = responseObject.results, 0 < results.count {
                        self.summaryLists[index].icoSummaries.append(contentsOf: results)
                    } else {
                        self.summaryLists[index].noMorePage = true
                    }
                } else {
                    self.summaryLists[index].noMorePage = true
                }
                success?(status)
            }) { (statusCode, errMsg) in
                failure?(errMsg)
            }
        } else {
            failure?("App: App: Access failed.")
        }
    }
}
