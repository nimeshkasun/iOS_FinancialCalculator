//
//  SharedFunctions.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import Foundation
import UIKit

class SharedFunctions
{
    func getFormattedAsDouble(value: Double) -> Double
    {
        return (value * 100).rounded() / 100
    }
    
    func getFormattedAsString(value: Double) -> String
    {
        return String(format: "%.02f", value)
    }
}

