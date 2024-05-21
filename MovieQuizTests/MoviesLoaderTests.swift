//
//  MoviesLoaderTests.swift
//  MovieQuizUITests
//
//  Created by Roman Romanov on 10.05.2024.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        Task {
            await loader.loadMovies { result in
                // Then
                switch result {
                case .success(let mostPopularMovies):
                    XCTAssertEqual(mostPopularMovies.items.count, 2)
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Unexpected failure")
                }
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        Task {
            await loader.loadMovies { result in
                // Then
                switch result {
                case .success(_):
                    XCTFail("Unexpected failure")
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
