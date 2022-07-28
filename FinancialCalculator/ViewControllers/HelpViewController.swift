//
//  HelpViewController.swift
//  FinancialCalculator
//
//  Created by user219229 on 7/23/22.
//

import UIKit

class HelpViewController: UIPageViewController {
    
    // variables
    var orderedViewControllers = [UIViewController]()
    var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setUpUI()
    }
    
    // custom methods
    func setUpUI()
    {
        self.view.backgroundColor = UIColor.backgroundColor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        orderedViewControllers.append(storyboard.instantiateViewController(withIdentifier:"savingsHelpVC"))
        orderedViewControllers.append(storyboard.instantiateViewController(withIdentifier:"mortgageHelpVC"))
        orderedViewControllers.append(storyboard.instantiateViewController(withIdentifier:"loanHelpVC"))
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],direction: .forward, animated: true, completion: nil)
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.selectorColor()
        
    }
    
    
}

extension HelpViewController : UIPageViewControllerDelegate{
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
}

// extensions

extension HelpViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = orderedViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        
        return orderedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = orderedViewControllers.firstIndex(of: viewController), index + 1 < orderedViewControllers.count else {
            return nil
        }
        
        return orderedViewControllers[index + 1]
    }
}
