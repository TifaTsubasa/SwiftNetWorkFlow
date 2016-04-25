//
//  ViewController.swift
//  SwiftNetWorkFlow
//
//  Created by TifaTsubasa on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let DOUBAN_URL = "https://api.douban.com/v2/movie/subject/1764796"
    let error = NSError(domain: "", code: 0, userInfo: nil)
    
//    let res = APIResult.Success(DOUBAN_URL)

    NetworkKit().fetch(DOUBAN_URL)
      .success { (json) in
        debugPrint("success")
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

