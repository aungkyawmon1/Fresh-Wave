//
//  API.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import Foundation

/// Define constants especially for network service.
class Api {
    
    /// Computed property that return baseURL from Bundle after decrypted
    static var baseUrl: String {
        return "http://54.169.160.194/api/auth/"
    }
    
    
      /// Computed property that return appToken from Bundle after decrypted
      static var appToken: String {
          return ""
      }
    
}
