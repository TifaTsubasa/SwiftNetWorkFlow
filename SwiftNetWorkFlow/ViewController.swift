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

class MovieLoader: NetworkKit {
  
  var resultHandler: (Movie -> Void)?
  
  func result(handler: (Movie -> Void)) -> MovieLoader {
    self.resultHandler = handler
    return self
  }
  
  func loadMovie() -> MovieLoader {
    let loader = self.fetch(DOUBAN_URL)
      .success { [weak self] (json) in
        self!.resultHandler?(Reflect.model(json: json, type: Movie.self))
      }.load()
    return loader
  }
  
  deinit {
    debugPrint("deinit")
  }
}

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   MovieLoader().result({ (movie) in
      debugPrint("movie - \(movie)")
    }).error({ (code, error) in
      debugPrint("code = \(code), error=\(error)")
    }).failure({ (error) in
      debugPrint("failure - \(error)")
    }).loadMovie()
    
  }

}

