//
//  SwiftNetWorkFlowTests.swift
//  SwiftNetWorkFlowTests
//
//  Created by TifaTsubasa on 16/4/25.
//  Copyright © 2016年 Upmer Inc. All rights reserved.
//

import XCTest
import TTReflect

@testable import SwiftNetWorkFlow

class SwiftNetWorkFlowTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testResult() {
    let expectation = expectationWithDescription("testResult")
    NetworkKit<Movie>().fetch("https://api.douban.com/v2/movie/subject/1764796")
    .reflect { (json) -> Movie in
      Reflect<Movie>.mapObject(json: json)
    }.result { (movie) in
      XCTAssertEqual(movie.title, "机器人9号")
      expectation.fulfill()
    }.request()
    waitForExpectationsWithTimeout(10, handler: nil)
  }
  
  func testError() {
    let expectation = expectationWithDescription("testError")
    NetworkKit<Movie>().fetch("https://api.douban.com/v2/movie/subject/176479")
      .reflect { (json) -> Movie in
        Reflect<Movie>.mapObject(json: json)
      }.error { (code, _) in
        XCTAssertEqual(code, 404)
        expectation.fulfill()
    }.request()
    waitForExpectationsWithTimeout(10, handler: nil)
  }
  
  func testFailure() {
    let expectation = expectationWithDescription("testFailure")
    NetworkKit<Movie>().fetch("htt://api.douban.com/v2/movie/subject/1764796")
      .reflect { (json) -> Movie in
        Reflect<Movie>.mapObject(json: json)
      }.failure { (error) in
        XCTAssertNotNil(error)
        expectation.fulfill()
    }.request()
    waitForExpectationsWithTimeout(10, handler: nil)
  }
  
}
