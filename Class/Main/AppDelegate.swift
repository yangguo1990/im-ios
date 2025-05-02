////
////  AppDelegate.swift
////  MeiLiao
////
////  Created by ganlingyun on 2024/1/21.
////
//
//import UIKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//    weak var mainVC: MainVC?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        initWindow()
//        config()
//        return true
//    }
//    
//    func config() {
//        UserCenter.appDidLuanch()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewAnimate), name: Constants.notify.login, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewAnimate), name: Constants.notify.logout, object: nil)
//    }
//
//    func initWindow() {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.backgroundColor = .systemBackground
//        window?.rootViewController = rootVC()
//        window?.makeKeyAndVisible()
//    }
//    
//    func rootVC() -> UIViewController {
//        if UserCenter.isLogin {
//            let vc = MainVC()
//            mainVC = vc
//            return vc
//        }else {
//            let navc = BaseNavigationVC(rootViewController: LoginVC())
//            return navc
//        }
//    }
//    @objc private func changeRootViewAnimate() {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else {
//            return
//        }
//        window.rootViewController = appDelegate.rootVC()
//        UIView.transition(with: window,
//                          duration: 0.5,
//                              options: .transitionCrossDissolve,
//                              animations: nil,
//                              completion: nil)
//    }
//}
//
