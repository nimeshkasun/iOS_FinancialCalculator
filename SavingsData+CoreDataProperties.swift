//
//  SavingsData+CoreDataProperties.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import Foundation
import CoreData


extension SavingsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingsData> {
        return NSFetchRequest<SavingsData>(entityName: "SavingsData")
    }

    @NSManaged public var compundsPerYear: Double
    @NSManaged public var futureValue: Double
    @NSManaged public var id: String?
    @NSManaged public var interest: Double
    @NSManaged public var payment: Double
    @NSManaged public var paymentMadeAt: Int16
    @NSManaged public var paymentsPerYear: Double
    @NSManaged public var presentValue: Double

}
