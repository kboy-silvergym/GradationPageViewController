//
//  GradationPageViewController.swift
//  GradationPageViewController
//
//  Created by Kei Fujikawa on 2018/11/28.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

enum TutorialNumber {
    case first
    case second
}

protocol TutorialVC: class {
    var number: TutorialNumber { get set }
}

public class GradationPageViewController: UIPageViewController {
    
    lazy var tutorial1: UIViewController = {
        let storyboard = UIStoryboard(name: "Tutorial1", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        
        if let tutorialVC = vc as? TutorialVC {
            tutorialVC.number = .first
        }
        return vc
    }()
    
    lazy var tutorial2: UIViewController = {
        let storyboard = UIStoryboard(name: "Tutorial2", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        
        if let tutorialVC = vc as? TutorialVC {
            tutorialVC.number = .second
        }
        return vc
    }()
    
    var currentNumber: TutorialNumber = .first
    
    private lazy var screenWidth = UIScreen.main.bounds.width
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([tutorial1], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.view.backgroundColor = .clear
        
        for subView in self.view.subviews {
            if let scrollView = subView as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
}

extension GradationPageViewController: UIPageViewControllerDataSource {
    // swipe to go left
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? TutorialVC else {
            return nil
        }
        switch vc.number {
        case .first:
            return nil
        case .second:
            return tutorial1
        }
    }
    
    // swipe to go right
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? TutorialVC else {
            return nil
        }
        switch vc.number {
        case .first:
            return tutorial2
        case .second:
            return nil
        }
    }
}

extension GradationPageViewController: UIScrollViewDelegate {
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let alpha = (offset - screenWidth) / screenWidth
        
        switch currentNumber {
        case .first:
            self.view.backgroundColor = UIColor.yellow.withAlphaComponent(alpha)
        case .second:
            let reverseAlpha = 1.0 + alpha
            self.view.backgroundColor = UIColor.yellow.withAlphaComponent(reverseAlpha)
        }
    }
}
