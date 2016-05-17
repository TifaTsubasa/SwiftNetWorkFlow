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
    NetworkKit<Movie>().fetch(DOUBAN_URL)
      .complete { (res) in
        do {
          debugPrint(try res.resolve())
          let model = try res.then { json in
            Reflect.model(json: json, type: Movie.self)
            }.resolve()
          self.resultHanlder?(model)
        } catch where error is ResultError {
          let err = error as! ResultError
          self.errorHandler?(err.statusCode, err.json)
        } catch {
          print("failure -- \(error)")
        }
      }.request()
  }
}

class TheatersLoader: NetworkKit<[Movie]> {
  func load() {
    NetworkKit<[Movie]>().fetch(THEATERS_URL)
      .complete { (res) in
        do {
          let json = try res.then { json in
            Reflect.modelArray(json: json["subjects"], type: Movie.self)
            }.resolve()
          debugPrint(json)
        } catch {
          print(error)
        }
      }.request()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    MovieLoader().result { (movie) in
      self.label.text = movie.title
    }.error({ (code, json) in
      debugPrint("code = \(code), json = \(json)")
    }).load()
    
//    TheatersLoader().result { (theaters) in
//      debugPrint(theaters)
//      debugPrint(theaters)
//    }.load()
  }

}

