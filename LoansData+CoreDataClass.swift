//
//  LoansData+CoreDataClass.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/28/22.
//

import Foundation
import CoreData

@objc(LoansData)
public class LoansData: NSManagedObject {

    convenience init(pv: Double, fv: Double, interest: Double, noOfPayments: Double, noOfCompounds: Double,payment: Double, id:String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        self.init(context: context)
        
        self.presentValue = pv
        self.futureValue = fv
        self.interest = interest
        self.paymentsPerYear = noOfPayments
        self.payment = payment
        self.compundsPerYear = noOfCompounds
        self.id = id
    }
}
