//
//  Utils.swift
//  iExpense
//
//  Created by Chris Boette on 10/19/23.
//

import Foundation

var currencyFormatter: FloatingPointFormatStyle<Double>.Currency {
    return .currency(code: Locale.current.currency?.identifier ?? "USD")
}
