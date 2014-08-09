import Foundation

class Downloader {
  let url: NSURL
  lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
  lazy var session: NSURLSession = NSURLSession(configuration: self.config)
  var running = false

  typealias JSONArrayCompletion = (AnyObject?) -> ()

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
    var error: NSError?
    let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error)
    if error != nil {
      println("Error parsing json: \(error)")
      completion(nil)
    } else {
      completion(json)
    }
  }
}

struct Episode {
  let id: Int
  let title: String
  let episodeDescription: String
  let number: Int
}

func parseEpisodes(json: AnyObject) -> [Episode] {
  var episodes: [Episode] = []
  if let array = json as? [ [ String : AnyObject ] ] {
    for container in array {
      let item: AnyObject? = container["episode"]
      if let dict = item as? [ String : AnyObject ] {
        if let episode = parseEpisode(dict) {
          episodes.append(episode)
        }
      }
    }
  } else {
    println("expected an outer array")
  }
  return episodes
}

func parseEpisode(dict: [ String : AnyObject ]) -> Episode? {
  if let id = dict["id"] as? NSNumber {
    if let title = dict["title"] as? NSString {
      if let description = dict["description"] as? NSString {
        if let number = dict["episode_number"] as? NSNumber {
          return Episode(id: id.integerValue,
              title: title,
              episodeDescription: description,
              number: number.integerValue)
        }
      }
    }
  }
  return nil
}

let downloader = Downloader("https://www.nsscreencast.com/api/episodes.json")
downloader.downloadJson() {
  (let maybeResponse) in
  //  println("Received \(jsonResponse)")
  if let jsonResponse: AnyObject = maybeResponse {
    for episode in parseEpisodes(jsonResponse) {
      println("Episode: \(episode.title)")
    }
  }
}

while downloader.running {
  println("waiting...")
  sleep(1)
}
