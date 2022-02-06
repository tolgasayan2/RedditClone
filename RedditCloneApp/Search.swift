//
//  Search.swift
//  RedditCloneApp
//
//  Created by Tolga Sayan on 1.02.2022.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
  
  enum State {
    case notSearchedYet
    case loading
    case noResults
    case results([Root])
  }

  private(set) var state: State = .notSearchedYet
  private var dataTask: URLSessionDataTask?

  func performSearch(for text: String, completion: @escaping SearchComplete) {
    if !text.isEmpty {
      dataTask?.cancel()

      state = .loading

      let url = redditSearch(searchText: text)

      let session = URLSession.shared
      dataTask = session.dataTask(with: url) {
        data, response, error in
        var newState = State.notSearchedYet
        var success = false
        // Was the search cancelled?
        if let error = error as NSError?, error.code == -999 {
          return
        }

        if let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200, let data = data {
          let posts = self.parse(data: data)
          if posts.isEmpty {
            newState = .noResults
          } else {
            
            newState = .results(posts)
            
          }
          success = true
        }

        DispatchQueue.main.async {
          self.state = newState
          completion(success)
        }
      }
      dataTask?.resume()
    }
  }
// MARK: - Private Methods
private func redditSearch(searchText: String) -> URL {
  let encodedText = searchText.addingPercentEncoding(
    withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
  let urlString = "https://www.reddit.com/r/\(encodedText)/top.json?count=20"

  let url = URL(string: urlString)
  return url!
}

private func parse(data: Data) -> [Root] {
  do {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let result = try decoder.decode(
      RedditPostOuter.self, from: data)
    for child in result.data.children {
        if let image = child.data.preview?.images.first {
          print(image.resolutions.first?.url)
        }
    }
    return result.data.children
    
  } catch {
    print("JSON Error: \(error)")
    return []
  }
}
}


