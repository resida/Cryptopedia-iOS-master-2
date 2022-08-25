//
//  NetStatusUtil.swift
//  ICOCO
//
//  Created by 구홍석 on 2017. 9. 1..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol NetStatusUtilProtocol {
    @objc optional func netStatusUtil(_ sender: NetStatusUtil, status: NetStatusUtil.NetStatus)
}

@objc class NetStatusUtil: NSObject {
    // MARK: - Definition
    @objc enum NetStatus: Int {
        case unknown
        case notReachable
        case viaWifi
        case viaCellular
    }
    
    // MARK: - Variable
    var reachability: NetworkReachabilityManager?
    @objc var delegate: NetStatusUtilProtocol?
    
    // MARK: - Lifecycle
    fileprivate override init() {
        super.init()
        self.reachability = NetworkReachabilityManager()
        self.reachability?.listener = { status in
            let stat = self.convert(status: status)
            DispatchQueue.main.async(execute: {
                self.delegate?.netStatusUtil?(self, status: stat)
            })
        }
    }
    
    @objc static let shared: NetStatusUtil = {
        let instance = NetStatusUtil()
        return instance
    }()
    
    deinit {
        self.stop()
    }
    
    // MARK: - Function
    @objc func start() {
        _ = self.reachability?.startListening()
    }
    
    @objc func stop() {
        self.reachability?.stopListening()
    }
    
    @objc func getStatus() -> NetStatusUtil.NetStatus {
        var stat = NetStatusUtil.NetStatus.unknown
        if let status = self.reachability?.networkReachabilityStatus {
            stat = self.convert(status: status)
        }
        
        return stat
    }
    
    @objc func canConnectToInternet() -> Bool {
        var canConnect = false
        let netStat = self.getStatus()
        if .viaWifi == netStat || .viaCellular == netStat {
            canConnect = true
        }
        return canConnect
    }
    
    func convert(status: Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus) -> NetStatus {
        var stat = NetStatusUtil.NetStatus.unknown
        switch status {
        case .unknown:
            stat = NetStatusUtil.NetStatus.unknown
            break
            
        case .notReachable:
            stat = NetStatusUtil.NetStatus.notReachable
            break
            
        case .reachable(let type):
            if type == .ethernetOrWiFi {
                stat = NetStatusUtil.NetStatus.viaWifi
            } else if type == .wwan {
                stat = NetStatusUtil.NetStatus.viaCellular
            }
            break
        }
        return stat
    }
}
