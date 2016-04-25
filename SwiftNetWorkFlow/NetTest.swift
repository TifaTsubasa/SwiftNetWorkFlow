//
//  NetTest.swift
//  SwiftNetWorkFlow
//
//  Created by 谢许峰 on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import Foundation

public enum TTResult<T> {
    case Success(T)
    case Failure(NSError, AnyObject?)
    
    public func flatMap<U>(@noescape transform: T throws -> U? ) rethrows
        -> TTResult<U> {
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
        -> TTResult<U> {
            return try flatMap { try transform($0) }
    }
}