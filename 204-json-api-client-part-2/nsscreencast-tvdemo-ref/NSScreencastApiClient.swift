//
//  NSScreencastApiClient.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/10/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

class NSScreencastApiClient : ApiClient {
    
    static let baseURL = "https://www.nsscreencast.com/api"
    
    enum Endpoints {
        case Episode(Int)
        
        var path: String {
            switch self {
            case .Episode(let id):
                return "/episodes/\(id)"
            }
        }
        
        var URL: NSURL {
            return NSURL(string: NSScreencastApiClient.baseURL + self.path)!
        }
    }
    
    static var sharedApiClient: NSScreencastApiClient = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        return NSScreencastApiClient(configuration: config)
    }()
    
    func fetchEpisode(id: Int, completion: ApiClientResult<Episode> -> Void) {
        let url = Endpoints.Episode(id).URL
        let request = NSURLRequest(URL: url)
        fetchResource(request, rootKey: "episode", completion: completion)
    }
}