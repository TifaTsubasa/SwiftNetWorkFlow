//
//  NetworkKit.swift
//  SwiftNetWorkFlow
//
//  Created by TifaTsubasa on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//  https://api.douban.com/v2/movie/subject/1764796

import Foundation
import Alamofire

enum Result {
  case Success
}

public enum APIResult<T> {
  case Success(T)
  case Failure(NSError, AnyObject?)
}

class NetworkKit {
  
  var url: String?
  var params: [String: AnyObject]?
  var header: [String: AnyObject]?
  
  var successHandler: (AnyObject -> Void)?
  var errorHandler: ((Int, NSError) -> Void)?
  
  func fetch(url: String) -> NetworkKit {
    self.url = url
    return self
  }
  
  func success(handler: (AnyObject -> Void)) -> NetworkKit {
    self.successHandler = handler
    return self
  }
  
  func error(handler: ((Int, NSError) -> Void)) -> NetworkKit {
    self.errorHandler = handler
    return self
  }
  
  func request() {
    if let url = url {
      Alamofire.request(.GET, url)
        .response { request, response, data, error in
          let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
          if let success = self.successHandler {
            success(json)
          }
      }
    }
  }
}