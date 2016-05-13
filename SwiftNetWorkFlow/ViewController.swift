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

class MovieLoader: NetworkKit<Movie> {
  
  func load() {
    NetworkKit<Movie>().fetch(DOUBAN_URL)
      .complete { (res) in
        do {
          let json = try res.then { json in
            Reflect.model(json: json, type: Movie.self)
            }.resolve()
          self.resultHanlder?(json)
        } catch where error is ResultError {
          print("error -- \(error)")
        } catch {
          print("failure -- \(error)")
        }
      }.request()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    MovieLoader().result { (movie) in
      debugPrint(movie)
      self.label.text = movie.title
    }.load()
    
  }

}

