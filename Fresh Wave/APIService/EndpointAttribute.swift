//
//  EndpointAttribute.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import Foundation
import Alamofire

typealias RequestBody = [String: Any]

enum Encoding {
    case query
    case json
    case none
}

struct EndpointAttribute {
    
    var route: String
    var method: HTTPMethod
    var parameters: Parameters? = nil
    var encoding: ParameterEncoding
    var authed: Bool
    
    /// Initialzie an endpoint attribute.
    ///
    /// - Parameters:
    ///   - path: URL path of network route.
    ///   - mehtod: HTTPMethod type used for network service.
    ///   - body: Parameters for network service.
    ///   - encoding: Encoding methods used to handle network request.
    ///   - authed: Used to check if the network service requeire authentication.
    ///
    init(path: String, method: HTTPMethod, body: RequestBody? = nil, encoding: Encoding, authed: Bool) {
        self.route = Api.baseUrl + path
        self.method = method
        self.parameters = body
        print("BaseURLRoute",route)
        switch encoding {
        case .query:
            self.encoding = URLEncoding.queryString
        case .json:
            self.encoding = JSONEncoding.default
        case .none:
            self.encoding = URLEncoding.default
            
        }
        
        self.authed = authed
        
       // EndpointAttribute.all.insert(self)
    }
    
    /// URL property of BaseURL + version + path
    var url: URL {
        URL(string: route)!
    }
}

extension EndpointAttribute: Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {}
    
    static func == (lhs: EndpointAttribute, rhs: EndpointAttribute) -> Bool {
        return lhs.route == rhs.route
    }
    
}
