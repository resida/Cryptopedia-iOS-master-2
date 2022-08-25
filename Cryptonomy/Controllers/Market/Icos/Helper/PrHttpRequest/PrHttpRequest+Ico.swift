//
//  PrHttpRequest+Ico.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import ObjectMapper

extension PrHttpRequest {
    func getIcoList(
        status: String, page: Int,
        success: ((Int?, IcoSummaryList?) -> Void)?,
        failure: ((Int?, String?) -> Void)?)
    {
        let urlStr = String(format: PrHttpRequest.ICO_BENCH_API_URL + "/icos/all", arguments: [])
        var params: Dictionary<String, Any> = [:]
        params["status"] = status
        params["page"] = page
        self.requestJsonIcoBench(method: "POST", urlStr: urlStr, params: params, success: { (statusCode, resultValue, data) in
            let resultObject = Mapper<IcoSummaryList>().map(JSONObject: resultValue)
            success?(statusCode, resultObject)
        }) { (statusCode, errMsg) in
            failure?(statusCode, errMsg)
        }
    }
    
    func getIcoProfile(
        icoId: Int,
        success: ((Int?, IcoProfile?) -> Void)?,
        failure: ((Int?, String?) -> Void)?)
    {
        let urlStr = String(format: PrHttpRequest.ICO_BENCH_API_URL + "/ico/%i", arguments: [icoId])
        let params: Dictionary<String, Any> = [:]
        self.requestJsonIcoBench(method: "POST", urlStr: urlStr, params: params, success: { (statusCode, resultValue, data) in
            let resultObject = Mapper<IcoProfile>().map(JSONObject: resultValue)
            success?(statusCode, resultObject)
        }) { (statusCode, errMsg) in
            failure?(statusCode, errMsg)
        }
    }
}
