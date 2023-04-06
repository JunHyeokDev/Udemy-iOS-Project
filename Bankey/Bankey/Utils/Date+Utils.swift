//
//  Date+Utils.swift
//  Bankey
//
//  Created by 김준혁 on 2023/04/06.
//

import Foundation

extension Date {
    
    static var bankeyDateFormmatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        return formatter
    }
    
    var monthDayYearString: String {
        let dateformatter = Date.bankeyDateFormmatter
        dateformatter.dateFormat = "MMM d, yyyy"
        return dateformatter.string(from: self)
    }
}
