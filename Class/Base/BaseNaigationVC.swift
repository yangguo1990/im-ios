//
//  BaseNaigationVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit

class BaseNavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background.main
        
        //透明导航条
        setupClearBar()
        
        //设置title 颜色
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.titleTextAttributes = textAttributes
        
        //设置item颜色
        navigationBar.tintColor = .black

        ///实现返回手势，重写了leftBarButtonItem会禁用系统的返回手势，所以需要重新实现
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
    
    func setupClearBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationVC: UIGestureRecognizerDelegate {
    ///实现返回手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
