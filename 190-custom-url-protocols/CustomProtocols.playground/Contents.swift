import Foundation
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()

class CustomProtocol : NSURLProtocol {
    var currentTask: NSURLSessionTask?
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        if let scheme = request.URL?.scheme where scheme == "foo" {
            return true
        }
        
        if propertyForKey("CustomProtocolHandled", inRequest: request) != nil {
            return false
        }
        
        return true
    }
   
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        let urlComponents = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false)!
        urlComponents.scheme = "http"
        urlComponents.path = "/idontexist"
        if let url = urlComponents.URL {
            return NSURLRequest(URL: url)
        } else {
            print("Could not create URL from components: \(urlComponents)")
            abort()
        }
        return request
    }
    
    override func startLoading() {
        
        let req = request.mutableCopy() as! NSMutableURLRequest
        CustomProtocol.setProperty(true, forKey: "CustomProtocolHandled", inRequest: req)
        
        currentTask = NSURLSession.sharedSession().dataTaskWithRequest(req) {
            data, response, error in
            
            if let e = error {
                self.client?.URLProtocol(self, didFailWithError: e)
            } else {
                self.client?.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy: .NotAllowed)
                self.client?.URLProtocol(self, didLoadData: data!)
                self.client?.URLProtocolDidFinishLoading(self)
            }
        }
        currentTask!.resume()
    }
    
    override func stopLoading() {
        currentTask?.cancel()
    }
}

NSURLProtocol.registerClass(CustomProtocol.self)


let url = NSURL(string: "http://nsscreencast.com")!

let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
    data, response, error in
    
    if let e = error {
        print("ERROR: \(e)")
    }
    
    if let http = response as? NSHTTPURLResponse {
        print("HTTP \(http.statusCode)")
    }
    
    if let data = data {
        let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(dataStr)
    }
}

task.resume()
