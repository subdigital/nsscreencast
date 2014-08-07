
import Foundation

/*let jsonString = "[ \"apples\", \"bananas\", \"cherries\" ]"*/
/*let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)*/
/*let json = JSValue.decode(jsonData!)*/
/**/
/*if let fruits = json >>= JSArray<String, JSString>.fromJSON {*/
/*  for fruit in fruits {*/
/*    println("Fruit: \(fruit)")*/
/*  }*/
/*}*/

let downloader = Downloader("https://www.nsscreencast.com/api/episodes.json")
downloader.downloadJson() {
  (let data) in

  let json = JSValue.decode(data)
  if let episodes = json >>> JSArray<Episode, Episode>.fromJSON {
    for episode in episodes {
      println("Episode: \(episode.title)")
    }
  }
}

while downloader.running {
    println("waiting...")
    sleep(1)
}
