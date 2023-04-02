//
//  DecimalUtils.swift
//  Bankey
//
//  Created by 김준혁 on 2023/04/03.
//

import Foundation

// We are going to extend 'Decimal' Type!
extension Decimal {
    var doubleValue : Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
