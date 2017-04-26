//
//  Repository.swift
//  GithubIssueTrackerAlamo
//
//  Created by Michael Le on 14/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
  var identifier: Int!
  var language: String!
  var url: String!
  var name: String!
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    identifier <- map["id"]
    language <- map["language"]
    url <- map["url"]
    name <- map["name"]
  }
}
