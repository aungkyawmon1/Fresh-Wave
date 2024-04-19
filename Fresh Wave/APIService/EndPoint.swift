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
    case registerCustomer(RequestBody)
    case userProfile
    case articles(RequestBody)
    case customerLogin(RequestBody)
    case placeOrder(RequestBody)
    case customerOrderHistory
    case nearestAgent
    case updateProfile(RequestBody)
    case checkPhone(RequestBody)
    case orderStatus
  
    /// Create header for network service
    var headers: HTTPHeaders? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    /// Computed property which returns an ``EndpointAttribute`` with path, method, body, encoding method and authed parameters.
    var attribute: EndpointAttribute {
        switch self {
            
        ///  Auth
        case .login(let body):
            return .init(path: "login", method: .post, body: body, encoding: .json, authed: false)
            
        case .registerCustomer(let body):
            return .init(path: "customerRegister", method: .post, body: body, encoding: .json, authed: false)
            
        case .userProfile:
            return .init(path: "user-profile", method: .get, body: nil, encoding: .none, authed: true)
            
        case .articles(let body):
            return .init(path: "posts", method: .get, body: body, encoding: .query, authed: true)
            
        case .customerLogin(let body):
            return .init(path: "customerLogin", method: .post, body: body, encoding: .json, authed: false)
            
        case .placeOrder(let body):
            return .init(path: "placeOrder", method: .post, body: body, encoding: .json, authed: true)
            
        case .customerOrderHistory:
            return .init(path: "customerOrderHistory", method: .get, body: nil, encoding: .none, authed: true)
            
        case .nearestAgent:
            return .init(path: "nearestAgent", method: .get, body: nil, encoding: .none, authed: true)
            
        case .updateProfile(let body):
            return .init(path: "update-profile", method: .post, body: body, encoding: .json, authed: true)
            
        case .checkPhone(let body):
            return .init(path: "checkPhone", method: .post, body: body, encoding: .json, authed: false)
            
        case .orderStatus:
            return .init(path: "order-status", method: .get, encoding: .none, authed: true)
     
        }
        
    }
    
}
