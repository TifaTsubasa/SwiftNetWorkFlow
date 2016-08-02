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

class NetworkKit<Model> {
  
  typealias SuccessHandlerType = (AnyObject? -> Void)
  typealias ErrorHandlerType = ((Int, AnyObject?) -> Void)
  typealias FailureHandlerType = (NSError? -> Void)
  typealias FinishHandlerType = (Void -> Void)
  
  typealias ResultHandlerType = (Model -> Void)
  typealias ReflectHandlerType = (AnyObject? -> Model)
  
  var type: HttpRequestType!
  var url: String?
  var params: [String: AnyObject]?
  var headers: [String: String]?
  
  var successHandler: SuccessHandlerType?
  var errorHandler: ErrorHandlerType?
  var failureHandler: FailureHandlerType?
  var finishHandler: FinishHandlerType?
  var resultHandler: ResultHandlerType?
  var reflectHandler: ReflectHandlerType?
  
  var httpRequest: Request?
  
  deinit {
    debugPrint("deinit")
  }
  
  func reflect(f: ReflectHandlerType) -> Self {
    reflectHandler = f
    return self
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
  
  func finish(handler: FinishHandlerType) -> Self {
    self.finishHandler = handler
    return self
  }
  
  func success(handler: SuccessHandlerType) -> Self {
    self.successHandler = handler
    return self
  }
  
  func result(handler: ResultHandlerType) -> Self {
    self.resultHandler = handler
    return self
  }
  
  func error(handler: ErrorHandlerType) -> Self {
    self.errorHandler = handler
    return self
  }
  
  func failure(handler: FailureHandlerType) -> Self {
    self.failureHandler = handler
    return self
  }
  
  func request() -> Self {
    let alamofireType = Method(rawValue: type.rawValue)!
    if let url = url {
      httpRequest = Alamofire.request(alamofireType, url, parameters: params, encoding: .URL, headers: headers)
        .response { request, response, data, error in
          self.finishHandler?()
          let statusCode = response?.statusCode
          if let statusCode = statusCode {  // request success
            let json: AnyObject? = data.flatMap {
              return try? NSJSONSerialization.JSONObjectWithData($0, options: .MutableContainers)
            }
            
            if statusCode == 200 {
              self.successHandler?(json)
              if let reflectHandler = self.reflectHandler {
                self.resultHandler?(reflectHandler(json))
              }
            } else {
              self.errorHandler?(statusCode, json)
            }
          } else {                          // request failure
            self.failureHandler?(error)
          }
      }
    }
    return self
  }
  
  func cancel() {
    httpRequest?.cancel()
  }
}