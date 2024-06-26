//
//  Preference.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import Foundation

import Foundation


enum PreferenceKeys: String {
    case isSplashed
    case isAuth
    case userInfo
    case agentInfo
    case isNewUser
    case isRemainderOn
    case authVerificationID
    case currentOrderNumber
    case currentOrder
    case floorNumber
    case remainderDate
}

class Preference {
    
    static func setValue(_ value: Any?, forKey key: PreferenceKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    static func getBool(forKey key: PreferenceKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func getString(forKey key: PreferenceKeys) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getData(forKey key: PreferenceKeys) -> Data? {
        return UserDefaults.standard.data(forKey: key.rawValue)
    }
    
    static func getDouble(forKey key: PreferenceKeys) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    
    static func getFloat(forKey key: PreferenceKeys) -> Float? {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
    
    static func getInteger(forKey key: PreferenceKeys) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    //MARK: - get String array
    static func getStringArray(forKey key: PreferenceKeys) -> [String] {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [String] ?? [String]()
    }
    
}


extension Preference {
    
    // UserInfo
    static func saveUserInfo(_ userInfo: UserVO) {
        do {
            try UserDefaults.standard.setObject(userInfo, forKey: PreferenceKeys.userInfo.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getUserInfo() -> UserVO? {
        do {
            return try UserDefaults.standard.getObject(forKey: PreferenceKeys.userInfo.rawValue, castTo: UserVO.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func removeUserInfo() {
        UserDefaults.standard.setValue(nil, forKey: PreferenceKeys.userInfo.rawValue)
    }
    
    // NearestAgentInfo
    static func saveNearestAgentInfo(_ userInfo: NearestAgentVO) {
        do {
            try UserDefaults.standard.setObject(userInfo, forKey: PreferenceKeys.agentInfo.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getNearestAgentInfo() -> NearestAgentVO? {
        do {
            return try UserDefaults.standard.getObject(forKey: PreferenceKeys.agentInfo.rawValue, castTo: NearestAgentVO.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // NearestAgentInfo
    static func saveCurrentOrderVO(_ orderVO: OrderVO) {
        do {
            try UserDefaults.standard.setObject(orderVO, forKey: PreferenceKeys.currentOrder.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getCurrentOrderVO() -> OrderVO? {
        do {
            return try UserDefaults.standard.getObject(forKey: PreferenceKeys.currentOrder.rawValue, castTo: OrderVO.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func removeOrderVO() {
        UserDefaults.standard.setValue(nil, forKey: PreferenceKeys.currentOrder.rawValue)
    }
    
    
    static func removeAgentInfo() {
        UserDefaults.standard.setValue(nil, forKey: PreferenceKeys.agentInfo.rawValue)
    }
    
}
