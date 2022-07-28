//
//  TabBarController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/20/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    //variables
    // set in MainViewControllers on click of collection item
    var selectedPassedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    // custom methods
    
    func setUpUI()
    {
        
        // set navigation bar image
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "HeaderBg.png")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
        self.navigationController?.isNavigationBarHidden = false
        
        // background color
        self.view.backgroundColor = UIColor.backgroundColor()
        
        // set tab bar items programatically
        let mortgageItem = UITabBarItem(title: NSLocalizedString("Mortgage", comment: ""), image: UIImage(named: "MortgageLine.png"), selectedImage: UIImage(named: "MortgageFill.png"))
        let savingsItem = UITabBarItem(title: NSLocalizedString("Savings", comment: ""),image: UIImage(named: "SavingsLine.png"), selectedImage: UIImage(named: "SavingsFill.png"))
        let loanItem = UITabBarItem(title: NSLocalizedString("Loan", comment: ""),image: UIImage(named: "LoansLine.png"), selectedImage: UIImage(named: "LoansFill.png"))
        
        // view controllers are embedded in a parent which has a scrollview - ScrollViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateSavingsVC = storyboard.instantiateViewController(withIdentifier: "scrollVC")
        let updateMortgageVC = storyboard.instantiateViewController(withIdentifier: "scrollVC")
        let updateLoanVC = storyboard.instantiateViewController(withIdentifier: "scrollVC")
        
        updateMortgageVC.tabBarItem = mortgageItem
        updateSavingsVC.tabBarItem = savingsItem
        updateLoanVC.tabBarItem = loanItem
        
        // pass the index to ScrollViewController in order to load the child controller view, in container
        (updateSavingsVC as! ScrollViewController).selectedTabIndex = 0
        (updateMortgageVC as! ScrollViewController).selectedTabIndex = 1
        (updateLoanVC as! ScrollViewController).selectedTabIndex = 2
        
        // programatically setting view controllers in tab bar
        let tabControllers = [updateSavingsVC,updateMortgageVC,updateLoanVC]
        self.viewControllers = tabControllers
        self.selectedIndex = selectedPassedIndex
    }
}
