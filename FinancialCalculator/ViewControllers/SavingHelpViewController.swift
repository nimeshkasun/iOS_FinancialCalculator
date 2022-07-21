//
//  SavingHelpViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/21/22.
//

import UIKit

class SavingHelpViewController: UIViewController {

    // outlets
    @IBOutlet weak var helpTitle: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // custom methods
    func setUpUI()
    {
        self.view.backgroundColor = UIColor.backgroundColor()
        self.helpTitle.text = NSLocalizedString("savings", comment: "")
        self.desc.text = NSLocalizedString("savingsHelp", comment: "")
    }
}
