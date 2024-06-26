//
//  ProfileViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/04/2024.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    
    
    var userName: String? {
        return Preference.getUserInfo()?.username
    }
    
    var address: String? {
        return Preference.getUserInfo()?.address
    }
}
