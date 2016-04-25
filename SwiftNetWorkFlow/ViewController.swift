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
  
  func fetchMovie() {
    
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let error = NSError(domain: "", code: 0, userInfo: nil)
    
//    let res = APIResult.Success(DOUBAN_URL)
    

    NetworkKit().fetch(DOUBAN_URL)
      .success { (data) in
        let movie = Reflect.model(data: data, type: Movie.self)
        
        debugPrint(data)
    }.error({ (statusCode, error) in
      debugPrint("error")
    })
      .request()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

