//
//  SavingsData+CoreDataClass.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import Foundation
import CoreData

@objc(SavingsData)
public class SavingsData: NSManagedObject {
    
    convenience init(pv: Double, fv: Double, interest: Double, noOfPayments: Double, noOfCompounds: Double,payment: Double, pmtMadeAt: Int16, id:String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        self.init(context: context)
        
        self.presentValue = pv
        self.futureValue = fv
        self.interest = interest
        self.paymentsPerYear = noOfPayments
        self.payment = payment
        self.compundsPerYear = noOfCompounds
        self.paymentMadeAt = pmtMadeAt
        self.id = id
    }
}
