import Foundation

class Downloader {
  let url: NSURL
  lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
  lazy var session: NSURLSession = NSURLSession(configuration: self.config)
  var running = false

  typealias JSONArrayCompletion = (Array<AnyObject>?) -> ()

  init(_ url: String) {
    self.url = NSURL(string: url)
  }

  func downloadJson(completion: JSONArrayCompletion) {
    let task = session.dataTaskWithURL(url) {
      (let data, let response, let error) in
        if let httpResponse = response as? NSHTTPURLResponse {
          println("got some data")
          switch(httpResponse.statusCode) {
            case 200:
              println("got a 200")
              self.parseJson(data, completion: completion)

            default:
              println("Got an HTTP \(httpResponse.statusCode)")
          }
        } else {
          println("I don't know how to handle non-http responses")
        }

        self.running = false
    }

    running = true
    task.resume()
  }

  func parseJson(data: NSData, completion: JSONArrayCompletion) {
    completion(nil)
  }
}


let downloader = Downloader("https://www.nsscreencast.com/api/episodes.json")
downloader.downloadJson() {
  (let jsonResponse) in
    println("Received \(jsonResponse)")
}

while downloader.running {
  println("waiting...")
  sleep(1)
}
