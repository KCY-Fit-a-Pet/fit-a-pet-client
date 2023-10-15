//
//  ApiStatusLogger.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/10/09.
//

import Foundation
import Alamofire

final class ApiStatusLogger : EventMonitor {
    let queue = DispatchQueue(label: "ApiStatusLogger")
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard let statusCode = request.response?.statusCode else{return}
        
        print("ApiStatusLogger - statusCode : \(statusCode)")
        debugPrint(request)
    }
}
