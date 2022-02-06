//
//  Listing.swift
//  RedditCloneApp
//
//  Created by Tolga Sayan on 1.02.2022.
//

import Foundation

struct RedditPostOuter: Decodable {
  let data: Listing
  
  
}

struct Root: Codable {
  let data: Post
}

struct Listing: Codable {
  var children = [Root]()
  
}

struct Post: Codable {
  
  
  var title: String? = ""
  
  var selftext: String? = ""
  var preview: Images?
  
}

struct Images : Codable {
  var images: [Resolutions]
}

struct Resolutions : Codable {
  var resolutions: [ImageURL]
}


struct ImageURL: Codable {
  let url: String
  
}







