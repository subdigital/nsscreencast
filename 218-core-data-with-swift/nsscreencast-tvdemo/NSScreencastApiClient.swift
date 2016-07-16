//
//  NSScreencastApiClient.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/11/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

class NSScreencastApiClient : ApiClient {
    
    static let baseURL = "https://www.nsscreencast.com/api"
    
    static var sharedApiClient: NSScreencastApiClient = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return NSScreencastApiClient(configuration: config)
    }()
    
    enum Endpoints {
        case Episode(Int)
        
        var url: NSURL {
            let path: String
            switch self {
            case .Episode(let id):
                path = "/episodes/\(id)"
            }
            
            return NSURL(string: NSScreencastApiClient.baseURL + path)!
        }
    }
    
    func fetchEpisode(id: Int, completion: ApiClientResult<Episode> -> Void) {
        let url = Endpoints.Episode(id).url
        let request = NSURLRequest(URL: url)
        fetchResource(request, rootKey: "episode", completion: completion)
    }
}