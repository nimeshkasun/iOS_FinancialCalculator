//
//  SavingsViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import UIKit
import Foundation
import CoreData

class SavingsViewController: UIViewController {

    // outlets
    @IBOutlet weak var presentValueTF: UITextField!
    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var noOfPaymentsTF: UITextField!
    @IBOutlet weak var noOfCompoundsTF: UITextField!
    @IBOutlet weak var pmtMadeAtSC: UISegmentedControl!
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var plusMinusSegment: UISegmentedControl!
    
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
        setUpUI()
        viewStoredData()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = NSLocalizedString("savings", comment: "")
        
        // add clear all button
        let clearItem = UIBarButtonItem(title: NSLocalizedString("clear", comment: ""), style: .plain, target: self, action:#selector(clearSavings(sender:)))
        self.navigationController?.navigationBar.topItem!.rightBarButtonItem = clearItem
    }
    
    @IBAction func onCalculate(_ sender: Any) {
        prepareValues()
        validate()
    }
    
    @IBAction func onPMTMadeAtChange(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: "SPMTMadeAt")
    }
    
    // custom methods
    func setUpUI()
    {
        initTextField(field: presentValueTF, key: "SPV")
        initTextField(field: futureValueTF, key: "SFV")
        initTextField(field: interestTF, key: "SI")
        initTextField(field: paymentTF, key: "SPMT")
        initTextField(field: noOfPaymentsTF, key: "SNoOfPayments")
        initTextField(field: noOfCompoundsTF, key: "SNoOfCompounds")
        
        calcButton.layer.cornerRadius = 18

        // restore data from userdefaults
        if defaults.object(forKey: "SPMTMadeAt") != nil
        {
            pmtMadeAtSC.selectedSegmentIndex = defaults.integer(forKey: "SPMTMadeAt")
        }
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
        presentValue = prepareEachValue(field: presentValueTF)
        futureValue = prepareEachValue(field: futureValueTF)
        interestRate = prepareEachValue(field: interestTF)
        payment = prepareEachValue(field: paymentTF)
        noOfPayments = prepareEachValue(field: noOfPaymentsTF)
        noOfCompounds = prepareEachValue(field: noOfCompoundsTF)
        isPMTEnd = pmtMadeAtSC.selectedSegmentIndex == 1 ? true : false
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
        if(presentValueTF.tag == 0)
        {
            emptyTF.append(presentValueTF)
            functionToPerform = calculatePresentValue
        }
        if(futureValueTF.tag == 0)
        {
            emptyTF.append(futureValueTF)
            functionToPerform = calculateFutureValue
        }
        if(interestTF.tag == 0)
        {
            emptyTF.append(interestTF)
            functionToPerform = calculateInterest
        }
        if(noOfPaymentsTF.tag == 0)
        {
            emptyTF.append(noOfPaymentsTF)
            functionToPerform = calculateNoOfPayment
        }
        if(noOfCompoundsTF.tag == 0)
        {
            emptyTF.append(noOfCompoundsTF)
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
                    paymentTF.text = "0"
                    payment = prepareEachValue(field: paymentTF)
                    
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
         presentValueTF.text = sharedFunctions.getFormattedAsString(value: presentValue)
         presentValueTF.answerDetected()
     }
    
    func calculateInterest()
    {
        let a =  1 / (noOfCompounds * noOfPayments)
        let b =  futureValue / presentValue
        interestRate = (pow(b,a) - 1) * noOfCompounds * 100
        interestTF.text = sharedFunctions.getFormattedAsString(value: interestRate)
        interestTF.answerDetected()
    }
    
    func calculateNoOfPayment()
    {
        let a =  log(futureValue / presentValue)
        let b =   log(1 + (interestRate/noOfCompounds)) * noOfCompounds
        noOfPayments = a/b
        noOfPaymentsTF.text = sharedFunctions.getFormattedAsString(value: noOfPayments)
        noOfPaymentsTF.answerDetected()
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
        
        paymentTF.text = sharedFunctions.getFormattedAsString(value: payment)
        futureValueTF.text = sharedFunctions.getFormattedAsString(value: futureValue)
        futureValueTF.answerDetected()

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
        paymentTF.text = sharedFunctions.getFormattedAsString(value: finalAnswer)
        paymentTF.answerDetected()
    }
 
    func displayAlert()
    {
         let alert = UIAlertController(title: "Alert", message: "Please leave one of the values blank to perform the calculation", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         self.present(alert, animated: true, completion: nil)
    }
    
    @objc func clearSavings(sender: UIBarButtonItem)
    {
        clearEachValue(field: presentValueTF)
        clearEachValue(field: futureValueTF)
        clearEachValue(field: interestTF)
        clearEachValue(field: paymentTF)
        clearEachValue(field: noOfPaymentsTF)
        clearEachValue(field: noOfCompoundsTF)
        
    }
    
    func clearEachValue(field: UITextField)
    {
        field.text=""
        field.clear()
        defaults.set("", forKey: field.customTag!)
    }
    
    @objc func textFieldDidChange(sender: UITextField)
    {
        defaults.set(sender.text, forKey: sender.customTag!)
    }
    
    // saving old calculations
    func storeCalculatedData()
    {

        let pmtMadeAt : Int16 = Int16(pmtMadeAtSC.selectedSegmentIndex)
        let id = String(NSDate().timeIntervalSince1970)
        
        _ = SavingsData.init(pv: presentValue, fv: futureValue, interest: interestRate, noOfPayments: noOfPayments, noOfCompounds: noOfCompounds, payment: payment, pmtMadeAt: pmtMadeAt, id: id, insertIntoManagedObjectContext: self.context)
        
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"SavingsData")
        do
        {
            let savingData = try self.context?.fetch(request) as! [SavingsData]
            if(savingData.count > 0 ){
            
                savingData.forEach {savingDataObj in
                
                     print("--------------------------")
                     print("Id",savingDataObj.id ?? "")
                     print("Present Value",savingDataObj.presentValue)
                     print("Future Value",savingDataObj.futureValue)
                     print("Interest Value",savingDataObj.interest)
                     print("Compunds perYear",savingDataObj.compundsPerYear)
                     print("Payments PerYear",savingDataObj.paymentsPerYear)
                     print("Payment",savingDataObj.payment)
                     print("Payment Made At",savingDataObj.paymentMadeAt)
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
