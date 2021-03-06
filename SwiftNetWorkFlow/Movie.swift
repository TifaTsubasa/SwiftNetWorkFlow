//
//  Movie.swift
//  SwiftNetWorkFlow
//
//  Created by 谢许峰 on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import UIKit

class Movie: NSObject {
  var reviews_count = 0
  var wish_count = 0
  var collect_count = 0
  var douban_site = ""
  var mobile_url = ""
  var share_url = ""
  var title: String = ""
  var id = ""
  var alt = ""
  var rating = Rating()
  var images = Images()
  
  func setupMappingObjectClass() -> [String : AnyClass] {
    return ["rating": Rating.self, "images": Images.self]
  }
}

class Rating: NSObject {
  var max = 0
  var average = 0.0
  var stars = ""
  var min = 0
}

class Images: NSObject {
  var small = ""
  var large = ""
  var medium = ""
  
}