//
//  Movie.swift
//  SwiftNetWorkFlow
//
//  Created by 谢许峰 on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import UIKit
import TTReflect

class Movie: NSObject {
  var reviews_count = 0
  var wish_count = 0
  var collect_count = 0
  var douban_site = ""
  var mobile_url = ""
  var share_url = ""
  var title = ""
  var id = ""
  var rating = Rating()
  var images = Images()
  
  func setupReplaceObjectClass() -> [String : String] {
    return ["rating": "Rating", "images": "Images"]
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