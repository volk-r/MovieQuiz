//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Roman Romanov on 12.05.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let label = app.staticTexts["1/10"]
        XCTAssert(label.waitForExistence(timeout: 3))
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        
        let secondLabel = app.staticTexts["2/10"]
        XCTAssert(secondLabel.waitForExistence(timeout: 2))
        let secondPoster = app.images["Poster"]
        XCTAssertEqual(indexLabel.label, "2/10")
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        let indexLabel = app.staticTexts["1/10"]
        XCTAssert(indexLabel.waitForExistence(timeout: 3))
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        
        let secondLabel = app.staticTexts["2/10"]
        XCTAssert(secondLabel.waitForExistence(timeout: 2))
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testGameFinished() {
        for i in 1...10 {
            let label = app.staticTexts["\(i)/10"]
            XCTAssert(label.waitForExistence(timeout: 3))
            app.buttons["No"].tap() 
        }
        
        let alert = app.alerts["alert"]
        XCTAssert(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testNewGameStarted() {
        for i in 1...10 {
            let label = app.staticTexts["\(i)/10"]
            XCTAssert(label.waitForExistence(timeout: 3))
            app.buttons["No"].tap()
        }
        
        let alert = app.alerts["alert"]
        XCTAssert(alert.waitForExistence(timeout: 2))
        alert.buttons.firstMatch.tap()
        
        let indexLabel = app.staticTexts["1/10"]
        XCTAssert(indexLabel.waitForExistence(timeout: 2))
    }
}
