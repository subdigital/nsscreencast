
import Foundation

let downloader = Downloader("https://www.nsscreencast.com/api/episodes.json")
downloader.downloadJson() {
  (let data) in

  if let json = JSValue.decode(data) {
    switch json {
      case let .JSArray(array):
        let maybeEpisodes: [Episode?] = array.map {
          switch $0 {
            case let .JSObject(d):
              
              let val: JSValue? = d["episode"]
              if let episodeDictionary = val {
                return Episode.fromJSON(episodeDictionary)
              } else {
                println("couldn't find episode key")
                return nil
              }
            default: return nil
          }
        }
        let episodes = compact(maybeEpisodes)
        for episode in episodes {
          println("Episode \(episode.number): \(episode.title)")
        }

      default:
        println("Expected an array")
    }
  }
}

while downloader.running {
    println("waiting...")
    sleep(1)
}
