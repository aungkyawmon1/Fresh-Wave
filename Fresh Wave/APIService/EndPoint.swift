//
//  EndPoint.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import Foundation
import Alamofire

/// Define and setup route for each network call.
enum Endpoint {
    
    /// Use to sign up with phone number
    case login(RequestBody)
  
    /// Create header for network service
    var headers: HTTPHeaders? {
        [
            "app_token": Api.appToken,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    /// Computed property which returns an ``EndpointAttribute`` with path, method, body, encoding method and authed parameters.
    var attribute: EndpointAttribute {
        switch self {
            
        ///  Auth
        case .login(let body):
            return .init(path: "/login", method: .post, body: body, encoding: .json, authed: false)
     
        }
        
    }
    
}
