//
//  NetworkKit.swift
//  SwiftNetWorkFlow
//
//  Created by TifaTsubasa on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//  https://api.douban.com/v2/movie/subject/1764796

import Foundation
import Alamofire

enum HttpRequestType: String {
  case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

class NetworkKit {
  
  typealias SuccessType = (AnyObject -> Void)
  typealias ErrorType = ((Int, AnyObject) -> Void)
  typealias FailureType = (NSError -> Void)
  
  var type: HttpRequestType!
  var url: String?
  var params: [String: AnyObject]?
  var headers: [String: String]?
  
  var successHandler: (AnyObject -> Void)?
  var errorHandler: ((Int, AnyObject) -> Void)?
  var failureHandler: (NSError -> Void)?
  
  var httpRequest: Request?
  
  deinit {
    debugPrint("deinit")
  }
  
  func fetch(url: String, type: HttpRequestType = .GET) -> Self {
    self.type = type
    self.url = url
    return self
  }
  
  func params(params: [String: AnyObject]) -> Self {
    self.params = params
    return self
  }
  
  func headers(headers: [String: String]) -> Self {
    self.headers = headers
    return self
  }
  
  func success(handler: (AnyObject -> Void)) -> Self {
    self.successHandler = handler
    return self
  }
  
  func error(handler: ((Int, AnyObject) -> Void)) -> Self {
    self.errorHandler = handler
    return self
  }
  
  func failure(handler: (NSError -> Void)) -> Self {
    self.failureHandler = handler
    return self
  }
  
  func load() -> Self {
    let alamofireType = Method(rawValue: type.rawValue)!
    if let url = url {
      httpRequest = Alamofire.request(alamofireType, url, parameters: params, encoding: .URL, headers: headers)
        .response { request, response, data, error in
          let statusCode = response?.statusCode
          
          if let statusCode = statusCode {  // request success
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)

            if statusCode == 200 {          // request success & respone right
              self.successHandler?(json)
              return
            } else {                        // request sucess & response error
              self.errorHandler?(statusCode, json)
              return
            }
          }
          if let error = error {            // request failure
            self.failureHandler?(error)
            return
          }
      }
    }
    return self
  }
  
  func cancel() {
    request?.cancel()
  }
}