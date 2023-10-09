//
//  MySearchRouter.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/10/09.
//

import Foundation
import Alamofire

enum MySearchRouter: URLRequestConvertible {
    
    case sendSms(phone: Int)
    case checkSms(phone: Int, code: Int)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "members/")! //여기서 나온 값이 baseURL이다.
    }

    var method: HTTPMethod {
        
        switch self{
        case .sendSms:
            return .get
        case .checkSms:
            return .get
        }
        
    }

    var path: String {
        switch self {
        case .sendSms:
            return "sms"
            
        case .checkSms:
            return "sms"
        }
    }
    
    var parameters : Parameters {
        switch self{
        case let .sendSms(phone)://enum으로 들어온 애를 사용하려면 let을 사용
            return ["phone" : phone]
        case let .checkSms(phone,code):
            return ["phone": phone, "code": code]
        }
    }

    func asURLRequest() throws -> URLRequest {
        print("MySearchRouter - asURLRequest()")
        
        let url = baseURL.appendingPathComponent(path) //url에다가 String을 붙인다.
        
        var request = URLRequest(url: url)
        request.method = method
        
        if method == .get {
           if let parameters = parameters as? [String: Any] {
               var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
               components?.queryItems = parameters.map { key, value in
                   URLQueryItem(name: key, value: "\(value)")
               }
               if let urlWithQuery = components?.url {
                   request.url = urlWithQuery
               }
           }
       }

        return request
    }
}
