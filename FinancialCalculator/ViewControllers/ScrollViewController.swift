//
//  ScrollViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/23/22.
//

import UIKit

class ScrollViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    // variables
    // set in TabBarController
    var selectedTabIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
            subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          unsubscribeFromAllNotifications()
    }
    
    // custom methods
    func setUpUI()
    {
        containerView.backgroundColor = UIColor.backgroundColor()
        initializeHideKeyboard()
        addChildController(index: selectedTabIndex)
    }
    
    // based on the index set children fot tab view controller
    func addChildController(index: Int)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var childVC: UIViewController
        if(index == 0)
        {
            childVC = storyboard.instantiateViewController(withIdentifier: "savingsVC")
        }
        else if(index == 1)
        {
            childVC = storyboard.instantiateViewController(withIdentifier: "mortgageVC")
        }
        else
        {
            childVC = storyboard.instantiateViewController(withIdentifier: "loanVC")
        }
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = self.containerView.bounds
        childVC.didMove(toParent: self)
    }
}


// keyboard Dismissal Handling on Tap
private extension ScrollViewController {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// textfield Visibility Handling with Scroll
private extension ScrollViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = scrollView, let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps the scroll view
            // We can do this because our scroll view's frame is already in our view's coordinate system
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset to avoid the keyboard
            // Don't forget the scroll indicator too!
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
