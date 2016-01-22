//
//  ApiClient.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

typealias JsonTaskCompletionHandler = (JSON?, NSHTTPURLResponse?, NSError?) -> Void

class ApiClient {
    
    let configuration: NSURLSessionConfiguration
    
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    var currentTasks: Set<NSURLSessionDataTask> = []
    
    var loggingEnabled = false
    
    init(configuration: NSURLSessionConfiguration) {
        self.configuration = configuration
    }
    
    func fetchResource<T : Decodable where T.DecodedType == T>(request: NSURLRequest, rootKey: String? = nil, completion: ApiClientResult<T> -> Void) {
        fetch(request, parseBlock: { (json) -> T? in
            
            let j: JSON
            if let root = rootKey {
                let rootJSON: Decoded<JSON> = (json <| root) <|> pure(json)
                j = rootJSON.value ?? .Null
            } else {
                j = json
            }
            
            return T.decode(j).value
            
            }, completion: completion)
    }
    
    func fetchCollection<T: Decodable where T.DecodedType == T>(request: NSURLRequest, rootKey: String? = nil, completion: ApiClientResult<[T]> -> Void) {
        fetch(request, parseBlock: { (json) in
            
            let j: JSON
            if let root = rootKey {
                let rootJSON: Decoded<JSON> = (json <| root) <|> pure(json)
                j = rootJSON.value ?? .Null
            } else {
                j = json
            }
            
            switch j {
            case .Array(let array):
                return array.map { T.decode($0).value! }
                
            default:
                print("Response was not an array, cannot continue")
                return nil
            }
            
            }, completion: completion)
    }
  
    func fetch<T>(request: NSURLRequest, parseBlock: JSON -> T?, completion: ApiClientResult<T> -> Void) {
        let task = jsonTaskWithRequest(request) { (json, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let e = error {
                    completion(.Error(e))
                } else {
                    switch response!.statusCode {
                    case 200:
                        if let resource = parseBlock(json!) {
                            completion(.Success(resource))
                        } else {
                            print("WARNING: Couldn't parse the following JSON as a \(T.self)")
                            print(json!)
                            completion(.UnexpectedResponse(json!))
                        }
                        
                    case 404: completion(.NotFound)
                    case 400...499: completion(.ClientError(response!.statusCode))
                    case 500...599: completion(.ServerError(response!.statusCode))
                    default:
                        print("Received HTTP \(response!.statusCode), which was not handled")
                        // should not happen
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func jsonTaskWithRequest(request: NSURLRequest, completion: JsonTaskCompletionHandler) -> NSURLSessionDataTask {
        var task: NSURLSessionDataTask?
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            self.currentTasks.remove(task!)
            let http = response as! NSHTTPURLResponse
            if let e = error {
                self.debugLog("Received an error from HTTP \(request.HTTPMethod!) to \(request.URL!)")
                self.debugLog("Error: \(e)")
                completion(nil, http, e)
            } else {
                self.debugLog("Received HTTP \(http.statusCode) from \(request.HTTPMethod!) to \(request.URL!)")
                if let data = data {
                    do {
                        self.debugResponseData(data)
                        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        let json = JSON.parse(jsonObject)
                        completion(json, http, nil)
                    } catch {
                        self.debugLog("Error parsing response as JSON")
                        completion(nil, http, NSError(domain: "com.nsscreencast.jsonerror", code: 10, userInfo: nil))
                    }
                } else {
                    self.debugLog("Received an empty response")
                    completion(nil, http, NSError(domain: "com.nsscreencast.emptyresponse", code: 11, userInfo: nil))
                }
            }
        })
        currentTasks.insert(task!)
        return task!
    }
    
    func debugLog(msg: String) {
        guard loggingEnabled else { return }
        print(msg)
    }
    
    func debugResponseData(data: NSData) {
        guard loggingEnabled else { return }
        if let body = String(data: data, encoding: NSUTF8StringEncoding) {
            print(body)
        } else {
            print("<empty response>")
        }
    }
}