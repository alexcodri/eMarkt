//
//  HelperFunctions.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    //getting from the location the current currency
    currencyFormatter.locale = Locale.current
    return currencyFormatter.string(from: NSNumber(value: number))!

}
