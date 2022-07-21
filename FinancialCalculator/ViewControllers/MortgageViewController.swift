//
//  MortgageViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/20/22.
//

import UIKit

class MortgageViewController: UIViewController {

    // outlets
    @IBOutlet weak var loanAmountTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var noOfYearsTF: UITextField!
    
    @IBOutlet weak var calcButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
       navigationController?.navigationBar.topItem!.title = NSLocalizedString("mortgage", comment: "")
        
        // add clear all button
       let clearItem = UIBarButtonItem(title: NSLocalizedString("clear", comment: ""), style: .plain, target: self, action:#selector(clearMortgage(sender:)))
       self.navigationController?.navigationBar.topItem!.rightBarButtonItem = clearItem
    }
    
    // custom methods
    
    // clear all text fields
    @objc func clearMortgage(sender: UIBarButtonItem)
    {
        clearEachValue(field: loanAmountTF)
        clearEachValue(field: interestTF)
        clearEachValue(field: paymentTF)
        clearEachValue(field: noOfYearsTF)
        
        calcButton.layer.cornerRadius = 18

    }
    
    func clearEachValue(field: UITextField)
    {
        field.text=""
        field.clear()
    }
}
