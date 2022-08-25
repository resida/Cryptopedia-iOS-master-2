//
//  APIManager+Alamofire.swift
//  Cryptonomy
//
//
//  Created by resida on 8/25/18.
//  Copyright © 2018 Dajour. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import PKHUD
import SwiftyUserDefaults

typealias MarketListResponseCompletion = ((_ result: MarketListResponse, _ success: Bool) -> ())

extension APIManager
{
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    func isInternetActive(failure:@escaping Failure) {
        if !Connectivity.isConnectedToInternet {
            failure(Message.msg_InternetNotActive)
            return
        }
    }
    
    //MARK: - Market List Screen
    
    func getAllMarketListDataPro(_ params: TickerParams, success: @escaping (() -> ()), failure: @escaping Failure) {
        Common.showLoading()
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(MarketListRouter.TickerDataPro(params: params))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<ListResponse>) in
                Common.hideLoading()
                switch completion.result {
                case .success(let data):
                    MarketList.shared.updateData(data)
                    success()
                case .failure(_):
                    failure(Message.msg_DefaultError)
                }
        }
    }
    
    //MARK: - Home Screen
    
    func getHomeHeaderDataCoinMarketCapPro(_ params: TickerParams, success:@escaping (_ result:[Datum]) -> Void,failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(MarketListRouter.TickerDataPro(params: params))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<ListResponse>) in
                if completion.result.error == nil {
                    success((completion.result.value?.data)!)
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    //MARK: - Get All Ticker Data
    
    func getAllTickerData(success:@escaping (_ result:[Datum]) -> Void,failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.TickerData)
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<MarketListResponse>) in
                if completion.result.error == nil {
                    success((completion.result.value?.data)!)
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    func getAllTickerDataPaging(start: Int, success:@escaping (_ result:MarketListResponse) -> Void,failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.TickerDataPaging(start: start))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<MarketListResponse>) in
                if completion.result.error == nil {
                    if let res = completion.result.value {
                        success(res)
                    }
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    func getAllCointListData(success:@escaping (_ result:[String: CoinData]) -> Void, failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        let decoder = JSONDecoder()
        Alamofire.request(TickerRouter.AllCoinList)
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<CoinListResponse>) in
                if completion.result.error == nil {
                    success((completion.result.value?.data)!)
                } else {
                    failure(Message.msg_DefaultError)
                }
        }
    }
    
    func getCoinDetailHistoMinute(params: Params, success: @escaping (_ result:CoinDetail) -> Void, failure: @escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom({ AnyKey(stringValue: $0.last!.stringValue.lowercased())!})
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.CoinDetailHistoMinute(params: params))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<CoinDetail>) in
                if completion.result.error == nil {
                    success(completion.result.value!)
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    func getCoinDetailHistoricalData(params: Params, detailChartType: DetailChartType ,success: @escaping (_ result:CoinDetail) -> Void, failure: @escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom({ AnyKey(stringValue: $0.last!.stringValue.lowercased())!})
        decoder.dateDecodingStrategy = .secondsSince1970
        
        var urlRequest: URLRequestConvertible? = nil
        if detailChartType.apiType == .CallTypeMinute {
            urlRequest = TickerRouter.CoinDetailHistoMinute(params: params)
        } else if detailChartType.apiType == .CallTypeHour {
            urlRequest = TickerRouter.CoinDetailHistoHour(params: params)
        } else if detailChartType.apiType == .CallTypeDay {
            urlRequest = TickerRouter.CoinDetailHistoDay(params: params)
        }
        
        Alamofire.request(urlRequest!)
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<CoinDetail>) in
                if completion.result.error == nil {
                    success(completion.result.value!)
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    func getCoinNewsData(success: @escaping (_ result:[DatumCoinNews]) -> Void, failure: @escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.CoinNews)
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: "Data", decoder: decoder) { (completion: DataResponse<[DatumCoinNews]>) in
                if completion.result.error == nil {
                    Common.hideLoading()
                    success(completion.result.value!)
                } else {
                    Common.hideLoading()
                    failure(Message.msg_DefaultError)
                }
        }
    }
    
    func getCoinSpecificNews(symbol: String, success: @escaping (_ result:[DatumCoinNews]) -> Void, failure: @escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.CoinSpecificNews(symbol: symbol))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: "Data", decoder: decoder) { (completion: DataResponse<[DatumCoinNews]>) in
                if completion.result.error == nil {
                    Common.hideLoading()
                    success(completion.result.value!)
                } else {
                    Common.hideLoading()
                    failure(Message.msg_DefaultError)
                }
        }
    }
    
    //MARK: - Home Screen
    
    func getHomeHeaderDataCoinMarketCap(success:@escaping (_ result:[Datum]) -> Void,failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(TickerRouter.HomeTickerData)
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<MarketListResponse>) in
                if completion.result.error == nil {
                    success((completion.result.value?.data)!)
                    Common.hideLoading()
                } else {
                    failure(Message.msg_DefaultError)
                    Common.hideLoading()
                }
        }
    }
    
    func getHomeHeaderChartData(symbol: String, success: @escaping (_ result: CoinDetail) -> Void, failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom({ AnyKey(stringValue: $0.last!.stringValue.lowercased())!})
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let params = Params(fsyms: symbol, tsyms: Defaults[.currentCurrency]!, limit: 48, aggregate: 30)
        
        Alamofire.request(TickerRouter.CoinDetailHistoMinute(params: params))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<CoinDetail>) in
                if completion.result.error == nil {
                    success(completion.result.value!)
                } else {
                    
                }
        }
    }
    
    //MARK: - Portfolio Ticker Data
    
    func getAllPortfolioTickerData(_ params: TickerParams, success:@escaping (() -> ()),failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(MarketListRouter.TickerDataPro(params: params))
            .validate(statusCode: 200..<300)
            .responseDecodableObject(keyPath: nil, decoder: decoder) { (completion: DataResponse<ListResponse>) in
                Common.hideLoading()
                switch completion.result {
                case .success(let data):
                    let pList = PortfolioManager.shared
                    pList.listResponse = data
                    pList.timestamp = Date().timeIntervalSince1970
                    success()
                case .failure(_):
                    failure(Message.msg_DefaultError)
                }
        }
    }
    
    //MARK: - Coin Snapshot by Id
    
    func getCoinSnapshotById(_ id: String, success: @escaping ((_ infoResponse: CoinInfoResponse) -> ()), failure:@escaping Failure) {
        self.isInternetActive(failure: failure)
        
        Alamofire.request(CoinInfoRouter.CoinSnapshotById(id: id))
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let result):
                    guard let _ = result as? [String: AnyObject] else {
                        failure(Message.msg_DefaultError)
                        return
                    }
                case .failure(_):
                    failure(Message.msg_DefaultError)
                }
        }
    }
}

class RequestChain {
    typealias CompletionHandler = (_ success:Bool, _ errorResult:ErrorResult?) -> Void
    
    struct ErrorResult {
        let request:DataRequest?
        let error:Error?
    }
    
    fileprivate var requests:[DataRequest] = []
    
    init(requests:[DataRequest]) {
        self.requests = requests
    }
    
    func start(_ completionHandler:@escaping CompletionHandler) {
        if let request = requests.first {
            request.response(completionHandler: { (response:DefaultDataResponse) in
                if let error = response.error {
                    completionHandler(false, ErrorResult(request: request, error: error))
                    return
                }
                
                self.requests.removeFirst()
                self.start(completionHandler)
            })
            request.resume()
        } else {
            completionHandler(true, nil)
            return
        }
    }
}
