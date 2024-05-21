//
//  DateFormatterTests.swift
//  MovieQuizUITests
//
//  Created by Roman Romanov on 10.05.2024.
//

import XCTest
@testable import MovieQuiz

final class DateFormatterTests: XCTestCase {
    func testDateTimeString() {
        // Given
        let string = "10 May 2024 11:57"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm"
        let date = dateFormatter.date(from: string)

        // When
        let value = date!.dateTimeString
        
        // Then
        XCTAssertEqual(value, "10.05.24 11:57")
    }
}
