//
//  KeychainService.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import Foundation
import KeychainAccess

class KeychainService {
    
    static let shared = KeychainService()
    private init() {}
    
    private let keychain = Keychain()
    
    func saveAccessToken(_ token: String) {
        do {
            try keychain.set(token, key: "access_token")
        } catch let error {
            print("KeychainSaveError:- Access Token, error:- \(error).")
        }
    }
    
    func getAccessToken() -> String? {
        do {
            return try keychain.getString("access_token")
        } catch let error {
            print("KeychainGetError:- Access Token, error:- \(error).")
            return nil
        }
    }
    
    func saveOrderNumber(_ number: String) {
        do {
            try keychain.set( number, key: "order_number")
        } catch let error {
            print("KeychainSaveError:- Access Token, error:- \(error).")
        }
    }
    
    func getOrderNumber() -> String? {
        do {
            return try keychain.getString("order_number")
        } catch let error {
            print("KeychainGetError:- Access Token, error:- \(error).")
            return nil
        }
    }
    
    func saveFloorNumber(_ number: String) {
        do {
            try keychain.set( number, key: "floor_number")
        } catch let error {
            print("KeychainSaveError:- Access Token, error:- \(error).")
        }
    }
    
    func getFloorNumber() -> String? {
        do {
            return try keychain.getString("floor_number")
        } catch let error {
            print("KeychainGetError:- Access Token, error:- \(error).")
            return nil
        }
    }
    
    func setNewUser(_ isNewUser: Bool) {
        do {
            try keychain.set( isNewUser ? "1" : "0", key: "is_new_user")
        } catch let error {
            print("KeychainSaveError:- Access Token, error:- \(error).")
        }
    }
    
    func getNewUser() -> Bool {
        do {
            let isNewUser = try keychain.getString("is_new_user")
            if isNewUser == "0" {
                return false
            } else {
                return true
            }
        } catch let error {
            print("KeychainGetError:- Access Token, error:- \(error).")
            return true
        }
    }
    
    func saveString(value: String, key: String) {
        do {
            try keychain.set(value, key: key)
        } catch let error {
            print("KeychainSaveError:- with key \(key), error:- \(error).")
        }
    }
    
    func remove(key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("KeychainRemoveError:- with key \(key), error:- \(error).")
        }
    }
    
    func format() {
        keychain.allKeys().forEach { remove(key: $0) }
    }
    
}
