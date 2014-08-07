struct Episode : JSONDecode {
  let id: Int
  let title: String
  let episodeDescription: String
  let number: Int

  typealias J = Episode
  static func fromJSON(j: JSValue) -> Episode? {
    switch j {
      case let .JSObject(d):

        if let innerEpisode = d["episode"] {
          return fromJSON(innerEpisode)
        }
        
        let id = d["id"] >>> JSInt.fromJSON ?? 0
        let title = d["title"] >>> JSString.fromJSON ?? "<untitled>"
        let descr = d["description"] >>> JSString.fromJSON ?? ""
        let number = d["episode_number"] >>> JSInt.fromJSON ?? 0
        return Episode(id: id,
            title: title,
            episodeDescription: descr,
            number: number)


      default:
        println("Expected a dictionary")
        return nil
    }
  }
}
