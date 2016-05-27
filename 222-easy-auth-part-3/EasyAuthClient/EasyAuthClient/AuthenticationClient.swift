//
//  AuthenticationClient.swift
//  EasyAuthClient
//
//  Created by Ben Scheirman on 5/25/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

struct AuthenticationRequest {
    var clientID: String?
    var token: String?
    var code: String?
    var error: NSError?
    var status: String?
    var authTokenData: String?
    
    init(error: NSError) {
        self.error = error
    }
    
    init(clientID: String, code: String, token: String) {
        self.clientID = clientID
        self.code = code
        self.token = token
    }
}

class AuthenticationClient {
    let session: NSURLSession
    let clientID: String
    let baseURL: NSURL
    
    init(clientID: String) {
        self.clientID = clientID
        self.session = NSURLSession.sharedSession()
        self.baseURL = NSURL(string: "http://localhost:9393")!
    }
    
    var activateURLString: String {
        return baseURL.URLByAppendingPathComponent("/activate").absoluteString
    }
    
    func requestCode(completion: (AuthenticationRequest) -> Void) {
        let url = baseURL.URLByAppendingPathComponent("/easy_auth")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = "client_id=\(clientID)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let mainCallback: (AuthenticationRequest) -> Void = { (request) in
            dispatch_async(dispatch_get_main_queue()) {
                completion(request)
            }
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if let e = error {
                mainCallback(AuthenticationRequest(error: e))
            } else {
                let http = response as! NSHTTPURLResponse
                let body = String(data: data!, encoding: NSUTF8StringEncoding)!
                if http.statusCode == 200 {
                    
                    let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    let code = (json["code"] as! NSNumber).integerValue
                    let codeString = "\(code)"
                    let token = json["token"] as! String
                    let authReq = AuthenticationRequest(clientID: self.clientID, code: codeString, token: token)
                    mainCallback(authReq)
                    
                } else {
                    print("Received HTTP \(http.statusCode)")
                    print("Body: \(body)")
                    let error = NSError(domain: "authError", code: http.statusCode, userInfo: ["body": body])
                    mainCallback(AuthenticationRequest(error: error))
                }
            }
        }
        
        task.resume()
    }
    
    func statusForRequest(authRequest: AuthenticationRequest, completion: (AuthenticationRequest) -> Void) {
        let url = baseURL.URLByAppendingPathComponent("/easy_auth/\(authRequest.token!)")
        
        let mainCallback: (AuthenticationRequest) -> Void = { (request) in
            dispatch_async(dispatch_get_main_queue()) {
                completion(request)
            }
        }
        
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            
            var updatedRequest = authRequest
            
            if let e = error {
                updatedRequest.error = e
            } else {
                let http = response as! NSHTTPURLResponse
                let body = String(data: data!, encoding: NSUTF8StringEncoding)!
                if http.statusCode == 200 {
                    
                    let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    updatedRequest.status = json["status"] as? String
                    if updatedRequest.status == "authenticated" {
                        updatedRequest.authTokenData = json["auth_token_data"] as? String
                    }
                } else {
                    print("Received HTTP \(http.statusCode)")
                    print("Body: \(body)")
                    let error = NSError(domain: "authError", code: http.statusCode, userInfo: ["body": body])
                    updatedRequest.error = error
                }
            }
            
            mainCallback(updatedRequest)
        }
        task.resume()
    }
}