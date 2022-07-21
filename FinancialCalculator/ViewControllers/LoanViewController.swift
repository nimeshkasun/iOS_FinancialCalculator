//
//  LoanViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/20/22.
//

import UIKit

class LoanViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var presentValTF: UITextField!
    @IBOutlet weak var futureValTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var noOfPaymentsTF: UITextField!
    @IBOutlet weak var noOFCompoundsTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = NSLocalizedString("loan", comment: "")
        
        // add clear all button
        let clearItem = UIBarButtonItem(title: NSLocalizedString("clear", comment: ""), style: .plain, target: self, action:#selector(clearLoan(sender:)))
        self.navigationController?.navigationBar.topItem!.rightBarButtonItem = clearItem
    }

    // custom methods
    
    // clear all text fields
    @objc func clearLoan(sender: UIBarButtonItem)
    {
        clearEachValue(field: presentValTF)
        clearEachValue(field: futureValTF)
        clearEachValue(field: interestTF)
        clearEachValue(field: noOfPaymentsTF)
        clearEachValue(field: noOFCompoundsTF)
        clearEachValue(field: paymentTF)
        
        calcButton.layer.cornerRadius = 18

    }
    
    func clearEachValue(field: UITextField)
    {
        field.text=""
        field.clear()
    }

}
