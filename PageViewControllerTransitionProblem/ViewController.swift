//
//  ViewController.swift
//  PageViewControllerTransitionProblem
//
//  Created by Heyosn on 30/10/2017.
//  Copyright © 2017 Heyson. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    @IBOutlet weak var constraintAdviewHeight: NSLayoutConstraint!
    weak var pageViewController : UIPageViewController?
    
    @IBOutlet weak var containerAdView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var containerPager: UIView!
    
    var currentIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController = pageVC
        pageVC.delegate = self
        pageVC.dataSource = self
        addChildViewController(pageVC)
        pageVC.didMove(toParentViewController: self)
        containerPager.addSubview(pageVC.view)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = true
        pageVC.view.frame = containerPager.bounds
        pushViewControllerForCurrentIndex()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerAdView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            self.simulateBannerLoad()
        }
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        currentIndex -= 1;
        pushViewControllerForCurrentIndex()
        
    }
    
    @IBAction func button2Clicked(_ sender: Any) {
        currentIndex += 1;
        pushViewControllerForCurrentIndex()
    }
    
    
    private func simulateBannerLoad(){
        constraintAdviewHeight.constant = 50
        pageViewController?.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3,
                       delay: 0, options: .allowUserInteraction, animations: {
                        self.containerAdView.isHidden = false
                        self.view.layoutIfNeeded()
                        self.pageViewController?.view.layoutIfNeeded()
        })
        
    }
    
    //MARK: data source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getViewControllerForIndex(currentIndex+1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getViewControllerForIndex(currentIndex-1)
    }
    
    func getViewControllerForIndex(_ index:Int) -> UIViewController? {
        guard (index>=0) else {return nil}
        let vc :UIViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "pageTest")
        vc.view.backgroundColor = (index % 2 == 0) ? .red : .green
        return vc
    }
    
    func pushViewControllerForCurrentIndex() {
        guard let vc = getViewControllerForIndex(currentIndex) else {return}
        pageViewController?.setViewControllers([vc], direction: .forward, animated: true, completion: { finished in
            
        })
    }
}
