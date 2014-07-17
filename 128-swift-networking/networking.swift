import Foundation

let config = NSURLSessionConfiguration.defaultSessionConfiguration()
let session = NSURLSession(configuration: config)

let term = "Cosmos"
let url = NSURL(string: "https://itunes.apple.com/search?term=\(term)")
let req = NSURLRequest(URL: url)
var wait = true
var json: String?
let task = session.dataTaskWithRequest(req) {
    (data, response, error)
    in
    if let httpResponse = response as? NSHTTPURLResponse {
      println("Received HTTP \(httpResponse.statusCode())")
      json = NSString(data: data, encoding: NSUTF8StringEncoding)
    } else {
      println("I don't know what to do with non-http responses")
    }
    wait = false
}

task.resume()

while json == nil {
  // wait for ctrl-c
}
println("Received response: \(json)")
