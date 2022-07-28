//
//  LoanViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/20/22.
//

import UIKit
import Foundation
import CoreData

class LoanViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var presentValField: UITextField!
    @IBOutlet weak var futureValField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var noOfPaymentsField: UITextField!
    @IBOutlet weak var noOfCompoundsField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    
    // variables
    let defaults = UserDefaults.standard
    let sharedFunctions = SharedFunctions()
    var noOfPayments: Double = 0
    var futureValue: Double = 0
    var presentValue: Double = 0
    var interestRate: Double = 0
    var payment: Double = 0
    var noOfCompounds: Double = 0
    var isPMTEnd: Bool = true
    var savingsData : SavingsData?
    var context: NSManagedObjectContext? {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func DidClickCalculate(_ sender: Any) {
        prepareValues()
        validate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = NSLocalizedString("Loan", comment: "")
        
        // add clear all button
        let clearItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: ""), style: .plain, target: self, action:#selector(clearLoan(sender:)))
        self.navigationController?.navigationBar.topItem!.rightBarButtonItem = clearItem
    }
    
    // custom methods
    
    // clear all text fields
    @objc func clearLoan(sender: UIBarButtonItem)
    {
        clearEachValue(field: presentValField)
        clearEachValue(field: futureValField)
        clearEachValue(field: interestField)
        clearEachValue(field: noOfPaymentsField)
        clearEachValue(field: noOfCompoundsField)
        clearEachValue(field: paymentField)
        
        calcButton.layer.cornerRadius = 18
        
    }
    
    func clearEachValue(field: UITextField)
    {
        field.text=""
        field.clear()
    }
    
    
    // custom methods
    func setUpUI()
    {
        initTextField(field: presentValField, key: "SPV")
        initTextField(field: futureValField, key: "SFV")
        initTextField(field: interestField, key: "SI")
        initTextField(field: paymentField, key: "SPMT")
        initTextField(field: noOfPaymentsField, key: "SNoOfPayments")
        initTextField(field: noOfCompoundsField, key: "SNoOfCompounds")
        
        calcButton.layer.cornerRadius = 18
        
    }
    
    func initTextField(field: UITextField, key: String)
    {
        // set text field delegate in the extension file - UITextFields
        field.setDelegate()
        
        // set customTag in the extension file - UITextFields
        field.customTag = key
        
        // on item change we store the data in userdefaults
        field.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        // restore data from userdefaults
        field.text = defaults.string(forKey: key)
    }
    
    // getting the values of textfields and formatting
    func prepareValues()
    {
        presentValue = prepareEachValue(field: presentValField)
        futureValue = prepareEachValue(field: futureValField)
        interestRate = prepareEachValue(field: interestField)
        payment = prepareEachValue(field: paymentField)
        noOfPayments = prepareEachValue(field: noOfPaymentsField)
        noOfCompounds = prepareEachValue(field: noOfCompoundsField)
    }
    
    func prepareEachValue(field: UITextField) -> Double
    {
        
        if let value = Double(field.text!) {
            field.tag = 1
            let formattedVal  = sharedFunctions.getFormattedAsDouble(value: value)
            field.text = sharedFunctions.getFormattedAsString(value: formattedVal)
            field.clear()
            return formattedVal
        } else {
            // tag is zero when there is no value
            field.tag = 0
            return 0
        }
    }
    
    func validate()
    {
        // add all the empty text fields to an array to show textfields in red
        var emptyTF = [UITextField] ()
        
        // store calculation method in a variable
        var functionToPerform : (() -> ())?
        
        // we need to perform the calculation on empty field
        if(presentValField.tag == 0)
        {
            emptyTF.append(presentValField)
            functionToPerform = calculatePresentValue
        }
        if(futureValField.tag == 0)
        {
            emptyTF.append(futureValField)
            functionToPerform = calculateFutureValue
        }
        if(interestField.tag == 0)
        {
            emptyTF.append(interestField)
            functionToPerform = calculateInterest
        }
        if(noOfPaymentsField.tag == 0)
        {
            emptyTF.append(noOfPaymentsField)
            functionToPerform = calculateNoOfPayment
        }
        if(noOfCompoundsField.tag == 0)
        {
            emptyTF.append(noOfCompoundsField)
        }
        
        
        // all fields are filled no empty fields. so display an alert
        if(emptyTF.count == 0)
        {
            displayAlert()
        }
        
        // found exaclty one empty field to perform our operation
        else if(emptyTF.count == 1)
        {
            interestRate = interestRate/100 //0.50
            
            //calculate future value based on PMT
            if(futureValue == 0)
            {
                calculateFutureValue()
            }
            else
            {
                if functionToPerform != nil
                {
                    // we need the payment value only when calculating future value, therefore clear payment value
                    paymentField.text = "0"
                    payment = prepareEachValue(field: paymentField)
                    
                    functionToPerform!()
                }
            }
            
            storeCalculatedData()
        }
        else
        {
            // show red text fields with animation
            emptyTF.forEach {tf in
                tf.errorDetected()
            }
        }
        
    }
    
    // calculations
    
    func calculatePresentValue()
    {
        let a =  noOfCompounds * noOfPayments
        let b =   1 + (interestRate/noOfCompounds)
        presentValue = futureValue / pow(b,a)
        presentValField.text = sharedFunctions.getFormattedAsString(value: presentValue)
        presentValField.answerDetected()
    }
    
    func calculateInterest()
    {
        let a =  1 / (noOfCompounds * noOfPayments)
        let b =  futureValue / presentValue
        interestRate = (pow(b,a) - 1) * noOfCompounds * 100
        interestField.text = sharedFunctions.getFormattedAsString(value: interestRate)
        interestField.answerDetected()
    }
    
    func calculateNoOfPayment()
    {
        let a =  log(futureValue / presentValue)
        let b =   log(1 + (interestRate/noOfCompounds)) * noOfCompounds
        noOfPayments = a/b
        noOfPaymentsField.text = sharedFunctions.getFormattedAsString(value: noOfPayments)
        noOfPaymentsField.answerDetected()
    }
    
    func calculateFutureValue()
    {
        let a = noOfCompounds * noOfPayments
        let b =  1 + (interestRate/noOfCompounds)
        futureValue = pow(b,a) * presentValue
        
        if(payment > 0)
        {
            if(isPMTEnd)
            {
                futureValue += calculateFutureValueofSeriesEnd(a: a, b: b)
            }
            else
            {
                futureValue += calculateFutureValueofSeriesBegining(a: a, b: b)
            }
        }
        
        paymentField.text = sharedFunctions.getFormattedAsString(value: payment)
        futureValField.text = sharedFunctions.getFormattedAsString(value: futureValue)
        futureValField.answerDetected()
        
    }
    
    
    func calculateFutureValueofSeriesEnd(a: Double, b: Double) -> Double
    {
        let answer: Double = payment * ((pow(b,a) - 1)/(interestRate/noOfCompounds))
        return answer
    }
    
    func calculateFutureValueofSeriesBegining(a: Double, b: Double) -> Double
    {
        let answer: Double = calculateFutureValueofSeriesEnd(a: a, b: b) * b
        return answer
    }
    
    func calculatePayment()
    {
        interestRate = interestRate/100
        
        let a =  noOfCompounds * noOfPayments
        let b =   1 + (interestRate/noOfCompounds)
        let c = ((pow(b,a) - 1)/(interestRate/noOfCompounds))
        
        let futureValueOfSeries: Double = futureValue - (pow(b,a) * presentValue)
        var finalAnswer: Double = 0
        
        if(isPMTEnd)
        {
            finalAnswer = futureValueOfSeries / c
        }
        else
        {
            finalAnswer = futureValueOfSeries / (c * b)
        }
        paymentField.text = sharedFunctions.getFormattedAsString(value: finalAnswer)
        paymentField.answerDetected()
    }
    
    func displayAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "Please leave one of the values blank to perform the calculation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func textFieldDidChange(sender: UITextField)
    {
        defaults.set(sender.text, forKey: sender.customTag!)
    }
    
    // saving old calculations
    func storeCalculatedData()
    {
        
        let id = String(NSDate().timeIntervalSince1970)
        
        _ = LoansData.init(pv: presentValue, fv: futureValue, interest: interestRate, noOfPayments: noOfPayments, noOfCompounds: noOfCompounds, payment: payment,id: id, insertIntoManagedObjectContext: self.context)
        
        do
        {
            try self.context?.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func viewStoredData()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"LoansData")
        do
        {
            let loansData = try self.context?.fetch(request) as! [LoansData]
            if(loansData.count > 0 ){
                
                loansData.forEach {loansDataObj in
                    
                    print("--------------------------")
                    print("Id",loansDataObj.id ?? "")
                    print("Present Value",loansDataObj.presentValue)
                    print("Future Value",loansDataObj.futureValue)
                    print("Interest Value",loansDataObj.interest)
                    print("Compunds perYear",loansDataObj.compundsPerYear)
                    print("Payments PerYear",loansDataObj.paymentsPerYear)
                    print("Payment",loansDataObj.payment)
                }
                
                
            }
            else
            {
                print("No results found")
            }
        }
        catch
        {
            print("Error in fetching items")
        }
    }
    
}
