//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by 김준혁 on 2023/04/03.
//

import Foundation
import XCTest

@testable import Bankey

class Test: XCTestCase {
    var formatter : CurrencyFormatter!
    
    
    override func setUp() {
        super.setUp()
        // brand new formatter so it's gonna be created whenever we test it
        formatter = CurrencyFormatter()
        
    }
    
    func testShouldBeVisible() throws {
        let res = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(res.0, "929,466")
        XCTAssertEqual(res.1, "23")
    }
    
    func testDollorsFormatted() throws {
        let res = formatter.dollarsFormatted(234234.23)
        XCTAssertEqual(res, "US$234,234.23")
    }
    
    func testZeroDollarsFormatted() throws {
        let res = formatter.dollarsFormatted(0.00)
        XCTAssertEqual(res, "US$0.00")
    }
    
    func testDollarsFormattedWithCurrencySymbol() throws {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "\(currencySymbol)929,466.23")
    }
}


