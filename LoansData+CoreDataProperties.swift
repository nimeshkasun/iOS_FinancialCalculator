//
//  LoansData+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/28/22.
//

import Foundation
import CoreData


extension LoansData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoansData> {
        return NSFetchRequest<LoansData>(entityName: "LoansData")
    }
    
    @NSManaged public var compundsPerYear: Double
    @NSManaged public var futureValue: Double
    @NSManaged public var id: String?
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var paymentsPerYear: Double
    @NSManaged public var presentValue: Double
    
}
