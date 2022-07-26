//
//  MortgageViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/20/22.
//

import UIKit

class MortgageViewController: UIViewController {

    // outlets
    @IBOutlet weak var loanAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var noOfYearsField: UITextField!
    
    @IBOutlet weak var calcButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func DidClickCalculate(_ sender: Any) {
        PreProcess()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationController?.navigationBar.topItem!.title = NSLocalizedString("Mortgage", comment: "")
        
        // add clear all button
       let clearItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: ""), style: .plain, target: self, action:#selector(clearMortgage(sender:)))
       self.navigationController?.navigationBar.topItem!.rightBarButtonItem = clearItem
    }
    
    // custom methods
    
    // clear all text fields
    @objc func clearMortgage(sender: UIBarButtonItem)
    {
        clearEachValue(field: loanAmountField)
        clearEachValue(field: interestField)
        clearEachValue(field: paymentField)
        clearEachValue(field: noOfYearsField)
        
        calcButton.layer.cornerRadius = 18

    }
    
    func clearEachValue(field: UITextField)
    {
        field.text=""
        field.clear()
    }
    
    var loanAmount: Double = 0;
    var interest : Double = 0;
    var payment : Double = 0;
    var noYears : Double = 0;
    var interestRate : Double = 0;
        
    let sharedFunctions = SharedFunctions()
    
    func calculatePayment(){
        interestRate = interest / 100
        let months = noYears * 12
        let a = 1 + interest
        let b = pow(a ,months)
        payment = ( loanAmount * interestRate * b ) / (b - 1)
        
        paymentField.text = sharedFunctions.getFormattedAsString(value: payment)
    }
    
    func calculateLoan(){
        interestRate = interest / 100
        let months = noYears * 12
        let a = 1 + interest
        let b = pow(a ,months)
        loanAmount = ( payment * (b-1)) / (interestRate * b)
        
        loanAmountField.text = sharedFunctions.getFormattedAsString(value: loanAmount)
    }
    
    func calculateN(){
        interestRate = interest / 100
        
        let a = log(payment) - log (payment - (loanAmount * interestRate))
        let b = log (1+interestRate)
        noYears = (a / b) / 12
        
        noOfYearsField.text = sharedFunctions.getFormattedAsString(value: noYears)
    }
    
    
    func displayAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "Snap!, Leave parameter empty that you need to calculate ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func PreProcess(){
        if let loan = Double(loanAmountField.text ?? "0.0") {
            loanAmountField.tag = 1
            loanAmount = sharedFunctions.getFormattedAsDouble(value: loan)
        } else {
            loanAmountField.tag = 0
        }
        
        if let intrst  = Double(interestField.text ?? "0.0") {
            interestField.tag = 1
            interest = sharedFunctions.getFormattedAsDouble(value: intrst)
        } else {
            interestField.tag = 0
        }
        
        if let pymnt = Double(paymentField.text ?? "0.0") {
            paymentField.tag = 1
            payment = sharedFunctions.getFormattedAsDouble(value: pymnt)
        } else {
            paymentField.tag = 0
        }
        
        if let noyrs = Double(noOfYearsField.text ?? "0.0") {
            noOfYearsField.tag = 1
            noYears = sharedFunctions.getFormattedAsDouble(value: noyrs)
        } else {
            noOfYearsField.tag = 0
        }
        
        calculations()
    }
    
    func calculations(){
        if paymentField.tag == 0 {
            calculatePayment();
        } else if loanAmountField.tag == 0{
            calculateLoan();
        } else if noOfYearsField.tag == 0 {
            calculateN()
        }else{
            displayAlert()
        }
        
    }
    
}
