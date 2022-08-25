//
//  PrHttpRequest.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 22..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CryptoSwift

// MARK: - PrHttpRequest
class PrHttpRequest {
    enum ContentType: String {
        case textPlain = "text/plain"
        case urlEncoded = "application/x-www-form-urlencoded;charset=UTF-8"
        case json = "application/json;charset=UTF-8"
        case multipartFormData = "multipart/form-data"
    }
    
    static let ICO_BENCH_API_URL = ICO_BENCH_SERVER_URL + "/api/v1"
    static let CCN_API_URL = CCN_SERVER_URL + "/feed"
}

// MARK: - Function
extension PrHttpRequest {
    func responsedErrorMessage(error: Error?, resultValue: Any?) -> String? {
        var errMsg: String? = nil
        if let resultValue = resultValue as? String {
            errMsg = "Server: " + resultValue
        } else if let errorMessage = error?.localizedDescription {
            errMsg = "System: " + errorMessage
        }
        return errMsg
    }
    
    func requestJsonIcoBench(
        method: String, urlStr: String,
        params: Dictionary<String, Any>,
        success: ((Int?, Any?, Data?) -> Void)?,
        failure: ((Int?, String?) -> Void)?)
    {
        var sig: String? = nil
        let keyBytes = ICO_BENCH_API_PRIVATE_KEY.bytes
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        if let jsonBytes = try? JSONSerialization.data(withJSONObject: params, options: []).bytes,
            let encodedBytes = ((try? HMAC(key: keyBytes, variant: .sha384).authenticate(jsonBytes).toBase64()) as String??)
        {
            sig = encodedBytes
        }
        
        var urlReq: URLRequest = URLRequest(url: URL(string: urlStr)!)
        urlReq.httpMethod = method
        urlReq.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        urlReq.setValue(ICO_BENCH_API_PUBLIC_KEY, forHTTPHeaderField: "X-ICObench-Key")
        urlReq.setValue("\(sig?.count ?? 0)", forHTTPHeaderField: "Content-Length")
        urlReq.setValue(sig, forHTTPHeaderField: "X-ICObench-Sig")
        urlReq.httpBody = jsonData
        
        // URL 인코딩.
        var encodedUrlReq: URLRequest? = nil
        do {
            encodedUrlReq = try URLEncoding.queryString.encode(urlReq, with: params)
        } catch let error {
            let errMsg = self.responsedErrorMessage(error: error, resultValue: nil)
            failure?(nil, errMsg)
            return
        }
        
        Alamofire.request(encodedUrlReq!).responseJSON(completionHandler: { (alamoResponse) in
            let response = alamoResponse.response
            let result = alamoResponse.result
            let data = alamoResponse.data
            if true == result.isSuccess {
                success?(response?.statusCode, result.value, data)
            } else {
                let errMsg = self.responsedErrorMessage(error: result.error, resultValue: result.value)
                failure?(response?.statusCode, errMsg)
            }
        })
    }
    
    func requestJsonCcn(
        method: String, urlStr: String,
        params: Dictionary<String, Any>,
        success: ((Int?, String?, Data?) -> Void)?,
        failure: ((Int?, String?) -> Void)?)
    {
        var urlReq: URLRequest = URLRequest(url: URL(string: urlStr)!)
        urlReq.httpMethod = method
        urlReq.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        
        // URL 인코딩.
        var encodedUrlReq: URLRequest? = nil
        do {
            encodedUrlReq = try URLEncoding.queryString.encode(urlReq, with: params)
        } catch let error {
            let errMsg = self.responsedErrorMessage(error: error, resultValue: nil)
            failure?(nil, errMsg)
            return
        }

        Alamofire.request(encodedUrlReq!).responseString { (alamoResponse) in
            let response = alamoResponse.response
            let result = alamoResponse.result
            let data = alamoResponse.data
            if true == result.isSuccess {
                success?(response?.statusCode, result.value, data)
            } else {
                let errMsg = self.responsedErrorMessage(error: result.error, resultValue: result.value)
                failure?(response?.statusCode, errMsg)
            }
        }
    }
}
