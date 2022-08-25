//
//  IcoProfileModel.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 25..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation

// MARK: - IcoProfileModel
class IcoProfileModel {
    internal let request = PrHttpRequest()
    var icoProfile: IcoProfile? = nil
}

// MARK: - Function
extension IcoProfileModel {
    func getIcoProfile(icoId: Int, success: (() -> Void)?, failure: ((String?) -> Void)?) {
        self.request.getIcoProfile(icoId: icoId, success: { (statusCode, icoProfile) in
            self.icoProfile = icoProfile
            success?()
        }) { (statusCode, errMsg) in
            failure?(errMsg)
        }
    }
}
