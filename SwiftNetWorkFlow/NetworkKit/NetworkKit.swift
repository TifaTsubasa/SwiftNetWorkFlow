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
  
  public func flatMap<U>(@noescape transform: T throws -> U? ) rethrows
    -> APIResult<U> {
      debugPrint(self)
      switch self {
      case let .Failure(error, obj):
        return .Failure(error, obj)
      case let .Success(value):
        guard let newValue = try transform(value) else {
          let err = NSError(domain: "", code: 1, userInfo: nil)
          return .Failure(err, nil)
        }
        return .Success(newValue)
      }
  }
  public func map<U>(@noescape transform: T throws -> U) rethrows
    -> APIResult<U> {
      return try flatMap { try transform($0) }
  }
}

class NetworkKit {
  
  var url: String?
  var params: [String: AnyObject]?
  var headers: [String: String]?
  
  var successHandler: (NSData -> Void)?
  var errorHandler: ((Int, NSError) -> Void)?
  var failureHandler: ((error: ErrorType?) -> Void)?
  
  func fetch(url: String) -> NetworkKit {
    self.url = url
    return self
  }
  
  func params(params: [String: AnyObject]) -> NetworkKit {
    self.params = params
    return self
  }
  
  func headers(headers: [String: String]) -> NetworkKit {
    self.headers = headers
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
  
  func failure(handler: (ErrorType? -> Void)) -> NetworkKit {
    self.failureHandler = handler
    return self
  }
  
  func request() {
    if let url = url {
      Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: headers)
        .response { request, response, data, error in
          let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
          if let success = self.successHandler {
            success(data!)
          }
      }
    }
  }
}

class Request {
//  func fetch<T, U>( transform: (T -> U)) -> APIResult<U> {
//    switch transform {
//    case let .Failure(error, obj):
//      return .Failure(error, obj)
//    default:
//      break
//    }
//    let success = APIResult.Success("fetch")
//    return success<U>
//  }
}