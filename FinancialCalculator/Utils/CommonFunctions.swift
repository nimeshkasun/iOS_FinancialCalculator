//
//  CommonFunctions.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import Foundation
import UIKit

class CommonFunctions
{
    func getFormattedDecimalDouble(value: Double) -> Double
    {
        return (value * 100).rounded() / 100
    }
    
    func getFormattedDecimalString(value: Double) -> String
    {
        return String(format: "%.02f", value)
    }
}

