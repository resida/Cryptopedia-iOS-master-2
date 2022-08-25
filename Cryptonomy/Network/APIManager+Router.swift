//
//  APIManager+Router.swift
//  Cryptonomy
//
//

import UIKit
import Alamofire

extension APIManager {
    enum TickerRouter: URLRequestConvertible {
        case TickerData
        case TickerDataPaging(start: Int)
        case AllCoinList
        case PriceMultiFull(params: Params)
        case CoinDetailHistoMinute(params: Params)
        case CoinDetailHistoHour(params: Params)
        case CoinDetailHistoDay(params: Params)
        case CoinNews
        case CoinSpecificNews(symbol: String)
        
        case HomeTickerData
        case PortfolioTickerData
    
        var method: HTTPMethod {
            switch self {
                case .TickerData, .AllCoinList, .PriceMultiFull, .CoinDetailHistoMinute, .CoinDetailHistoHour, .CoinDetailHistoDay, .CoinNews, .HomeTickerData
                ,.CoinSpecificNews, .PortfolioTickerData, .TickerDataPaging:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .TickerData:
                return makeAppUrl(endpoint: .allTickers)
            case .TickerDataPaging(let start):
                return makeAppUrlCoinMarketCap(endpoint: .allTickers, start: start)
            case .AllCoinList:
                return  makeCryptoBaseUrl(endpoint: .allCoinList)
            case .PriceMultiFull:
                return  makeCryptoBaseUrl(endpoint: .priceMultiFull)
            case .CoinDetailHistoMinute:
                return  makeCryptoDetailUrl(endpoint: .coinListDetailMinute)
            case .CoinDetailHistoHour:
                return  makeCryptoDetailHourUrl(endpoint: .coinListDetailHour)
            case .CoinDetailHistoDay:
                return  makeCryptoDetailDayUrl(endpoint: .coinListDetailDay)
            case .CoinNews:
                return makeCryptoBaseUrl(endpoint: .coinNews)
            case .HomeTickerData:
                return makeAppUrl(endpoint: .homeHeaderTickers)
            case .CoinSpecificNews:
                return makeCryptoBaseUrl(endpoint: .coinNews)
            case .PortfolioTickerData:
                return makePortfolioTickerUrl(endpoint: .portfolioAllTickers)
            }
        }
        
        var params: ([String: Any]?) {
            switch self {
            case .TickerData, .HomeTickerData, .PortfolioTickerData, .TickerDataPaging( _):
                return [:]
            case .AllCoinList:
                return [:]
            case .PriceMultiFull(let params):
                return ["fsyms": params.fsyms!, "tsyms": params.tsyms!]
            case .CoinDetailHistoMinute(let params), .CoinDetailHistoHour(let params), .CoinDetailHistoDay(let params):
                return ["fsym": params.fsyms!, "tsym": params.tsyms!, "limit": params.limit!, "aggregate": params.aggregate!]
            case .CoinNews:
                return ["feeds":"coindesk,ccn,trustnodes,bitcoinmagazine,yahoofinance"]
            case .CoinSpecificNews(let symbol):
                return ["categories": symbol]
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = URL(string:path)!
            var urlRequest = URLRequest(url:url)
            urlRequest.httpMethod = method.rawValue
            
            let encoding = URLEncoding.default
            return try encoding.encode(urlRequest, with: params)
        }
    }
    
    enum MarketListRouter: URLRequestConvertible {
        case TickerDataPro(params: TickerParams)
        
        var method: HTTPMethod {
            switch self {
            case .TickerDataPro:
                return .get
            }
        }
        
        var headers: HTTPHeaders {
            switch self {
            case .TickerDataPro:
                return [
                    "X-CMC_PRO_API_KEY": Global.CoinMarketCapAPIKey,
                    "Accept": "application/json"
                ]
            }
        }
        
        var path: String {
            switch self {
            case .TickerDataPro:
                return marketListProUrl(endpoint: .allTickersPro)
            }
        }
        var params: ([String: Any]?) {
            switch self {
            case .TickerDataPro(let params):
                return ["sort": params.sort, "start":params.start, "limit": params.limit, "cryptocurrency_type": params.cryptocurrencyType, "convert": params.convert]
            }
        }
        func asURLRequest() throws -> URLRequest {
            let url = URL(string:path)!
            var urlRequest = URLRequest(url:url)
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.allHTTPHeaderFields = headers
            
            let encoding = URLEncoding.default
            return try encoding.encode(urlRequest, with: params)
        }
    }
    
    enum CoinInfoRouter: URLRequestConvertible {
        case CoinSnapshotById(id: String)
        
        var method: HTTPMethod { return .get }
        var path: String { return APIManager.makeCryptoCompareCoinSnapshot(endpoint: .coinSnapshotById) }
        var params: ([String: Any]?) {
            switch self {
            case .CoinSnapshotById(let id):
                return ["id": id]
            }
        }
        func asURLRequest() throws -> URLRequest {
            let url = URL(string:path)!
            var urlRequest = URLRequest(url:url)
            urlRequest.httpMethod = method.rawValue
            let encoding = URLEncoding.default
            return try encoding.encode(urlRequest, with: params)
        }
    }
}
