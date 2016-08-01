//
//  ViewController.swift
//  SwiftNetWorkFlow
//
//  Created by TifaTsubasa on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import UIKit
import Alamofire
import TTReflect


let DOUBAN_URL = "https://api.douban.com/v2/movie/subject/1764796"
let THEATERS_URL = "https://api.douban.com/v2/movie/in_theaters"

class MovieLoader: NetworkKit<Movie> {
  
  func load() -> Self {
    return self.fetch(DOUBAN_URL)
    .reflect { (json) -> Movie in
      Reflect<Movie>.mapObject(json: json)
    }.request()
  }
}

class TheatersLoader: NetworkKit<[Movie]> {
  func load() -> Self {
    let f: AnyObject -> [Movie] = {json in
      let models = Reflect<Movie>.mapObjects(json: json["subjects"])
      return models
    }
    return self.fetch(THEATERS_URL).reflect(f).request()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NetworkKit<Movie>().fetch(DOUBAN_URL)
    .reflect { (json) -> Movie in
      Reflect<Movie>.mapObject(json: json)
    }.success({ (json) in
      print(json)
    }).result { (movie) in
      print(movie)
    }.request()
    
//    MovieLoader().result { (movie) in
//      print(movie)
//    }.error({ (code, json) in
//      print(code, json)
//    }).failure({ (error) in
//      print("error: ", error)
//    }).load()
    
//    MovieLoader().result { (movie) in
//      self.label.text = movie.title
////      debugPrint(movie.rating.average)
//    }.error({ (code, json) in
//      debugPrint("code = \(code), json = \(json)")
//    }).failure({ (error) in
//      debugPrint("failure = \(error)")
//    }).load()
//    
    TheatersLoader().result { (theaters) in
//      debugPrint(theaters)
    }.load()
  }

}

