//
//  AuthStore.swift
//  EasyAuthClient
//
//  Created by Ben Scheirman on 5/25/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

class AuthStore {
    static let instance = AuthStore()
    
    var authToken: String?
    
    var isLoggedIn: Bool {
        return authToken != nil
    }
}