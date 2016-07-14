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
  
  func load() {
    self.fetch(DOUBAN_URL)
      .complete { [weak self] (res) in
        self?.resultTract(res.then { Reflect<Movie>.mapObject(json: $0)} )
      }
  }
}

class TheatersLoader: NetworkKit<[Movie]> {
  func load() {
    let a: AnyObject -> [Movie] = {json in
      debugPrint(json["subjects"])
      let models = Reflect<Movie>.mapObjects(json: json["subjects"])
      debugPrint(models.count)
      return models
    }
    self.fetch(THEATERS_URL)
      .complete { [weak self] (res) in
        self?.resultTract(res.then(a) )
      }
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    MovieLoader().result { (movie) in
      self.label.text = movie.title
//      debugPrint(movie.rating.average)
    }.error({ (code, json) in
      debugPrint("code = \(code), json = \(json)")
    }).failure({ (error) in
      debugPrint("failure = \(error)")
    }).load()
    
    TheatersLoader().result { (theaters) in
      debugPrint(theaters)
    }.load()
  }

}

