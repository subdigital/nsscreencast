//
//  AuthStore.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import SSKeychain

class AuthStore {
    static let instance = AuthStore()
    
    static let KeychainServiceName = "OperationScreencast"
    static let KeychainAccount = "currentUser"
    
    func login(authToken: String) {
        SSKeychain.setPassword(authToken, forService: AuthStore.KeychainServiceName, account: AuthStore.KeychainAccount)
    }
    
    func logout() {
        SSKeychain.deletePasswordForService(AuthStore.KeychainServiceName, account: AuthStore.KeychainAccount)
    }
    
    func savedAuthToken() -> String? {
        return SSKeychain.passwordForService(AuthStore.KeychainServiceName, account: AuthStore.KeychainAccount)
    }
    
    func isLoggedIn() -> Bool {
        return savedAuthToken() != nil
    }
}