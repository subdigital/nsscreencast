//: Playground - noun: a place where people can play

import Foundation
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()


func request(url: NSURL) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url) { data, response, error in
        if let http = response as? NSHTTPURLResponse {
            print("Received HTTP \(http.statusCode)")
            let body = String(data: data!, encoding: NSUTF8StringEncoding)!
            print(body)
        }
    }
    task.resume()
}

let baseURL = NSURL(string: "http://httpbin.org")!

enum Endpoint {
    case UserAgent
    case Links(Int)
    
    func url() -> NSURL {
        switch self {
        case .UserAgent:
            return baseURL.URLByAppendingPathComponent("/user-agent")
        case .Links(let n):
            return baseURL.URLByAppendingPathComponent("/links/\(n)")
        }
    }
}


request(Endpoint.UserAgent.url())
request(Endpoint.Links(5).url())