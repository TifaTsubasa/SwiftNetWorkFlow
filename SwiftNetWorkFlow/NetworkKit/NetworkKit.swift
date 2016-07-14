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

struct ResultError: ErrorType {
  let statusCode: Int
  let json: AnyObject
}

enum Result<T> {
  case Success(T)
  case Error(Int, AnyObject)
  case Failure(NSError)
  
  func then<U>(f: T -> U) -> Result<U> {
    switch self {
    case .Success(let t): return .Success(f(t))
    case .Error(let code, let json): return .Error(code, json)
    case .Failure(let err): return .Failure(err)
    }
  }
  
  func then<U>(tranform: T -> Result<U>) -> Result<U> {
    switch self {
    case .Success(let value):
      return tranform(value)
    case .Error(let code, let json):
      return .Error(code, json)
    case .Failure(let error):
      return .Failure(error)
    }
  }
  
  func resolve() throws -> T {
    switch self {
    case .Success(let value):
      return value
    case .Error(let code, let json):
      throw ResultError(statusCode: code, json: json)
    case .Failure(let error):
      throw error
    }
  }
}

class NetworkKit<Model> {
  
  typealias SuccessType = (AnyObject -> Void)
  typealias ErrorType = ((Int, AnyObject) -> Void)
  typealias FailureType = (NSError -> Void)
  
  var type: HttpRequestType!
  var url: String?
  var params: [String: AnyObject]?
  var headers: [String: String]?
  
  var successHandler: SuccessType?
  var errorHandler: ErrorType?
  var failureHandler: FailureType?
  var resultHanlder: (Model -> Void)?
  var completeHandler: (Result<AnyObject> -> Void)?
  
  var httpRequest: Request?
  
  deinit {
    debugPrint("deinit")
  }
  
  func resultTract(res: Result<Model>) {
    do {
      let model = try res.resolve()
      self.resultHanlder?(model)
    } catch where error is ResultError {
      let err = error as! ResultError
      self.errorHandler?(err.statusCode, err.json)
    } catch {
      let err = error as NSError
      self.failureHandler?(err)
    }
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
  
  func success(handler: SuccessType) -> Self {
    self.successHandler = handler
    return self
  }
  
  func result(handler: (Model -> Void)) -> Self {
    self.resultHanlder = handler
    return self
  }
  
  func error(handler: ErrorType) -> Self {
    self.errorHandler = handler
    return self
  }
  
  func failure(handler: FailureType) -> Self {
    self.failureHandler = handler
    return self
  }
  
  func complete(handler: (Result<AnyObject> -> Void)) -> Self {
    self.completeHandler = handler
    return request()
  }
  
  func request() -> Self {
    let alamofireType = Method(rawValue: type.rawValue)!
    if let url = url {
      httpRequest = Alamofire.request(alamofireType, url, parameters: params, encoding: .URL, headers: headers)
        .response { request, response, data, error in
          let statusCode = response?.statusCode
          
          if let statusCode = statusCode {  // request success
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            
            if statusCode == 200 {          // request success & respone right
              self.successHandler?(json)
              self.completeHandler?(Result.Success(json))
              return
            } else {                        // request sucess & response error
              self.completeHandler?(Result.Error(statusCode, json))
              return
            }
          }
          if let error = error {            // request failure
            self.completeHandler?(Result.Failure(error))
            return
          }
      }
    }
    return self
  }
  
  func cancel() {
    httpRequest?.cancel()
  }
}