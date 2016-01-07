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
    
    init(configuration: NSURLSessionConfiguration) {
        self.configuration = configuration
    }
    
    // { "items": [ {name: "Burrito" }, {name: "Enchiladas"}, {} ] }
    // { "item": { name: "Taco" } }
    
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
                completion(nil, http, e)
            } else {
                if let data = data {
                    do {
                        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        let json = JSON.parse(jsonObject)
                        completion(json, http, nil)
                    } catch {
                        completion(nil, http, NSError(domain: "com.nsscreencast.jsonerror", code: 10, userInfo: nil))
                    }
                } else {
                    completion(nil, http, NSError(domain: "com.nsscreencast.emptyresponse", code: 11, userInfo: nil))
                }
            }
        })
        currentTasks.insert(task!)
        return task!
    }
}