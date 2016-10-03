//
//  APIClient.swift
//  CoreData10
//
//  Created by Ben Scheirman on 9/27/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case error(Error)
    case success([T])
    case unexpectedResponse
}

typealias JSONDictionary = [String:Any]

class APIClient {
    let configuration = URLSessionConfiguration.default
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()

    func fetchEpisodes(completion: @escaping (APIResult<EpisodeResponse>) -> Void) {
        let url = URL(string: "https://www.nsscreencast.com/api/episodes")!
        let task = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(.error(e))
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? JSONDictionary,
                    let episodesJSON = json?["episodes"] as? [JSONDictionary] {

                    let episodes = episodesJSON.map(EpisodeResponse.init).flatMap { $0! }
                    DispatchQueue.main.async {
                        completion(.success(episodes))
                    }

                } else {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Unexpected response received: \(responseString)")
                    DispatchQueue.main.async { completion(.unexpectedResponse) }
                }
            }
        }
        task.resume()
    }
}
