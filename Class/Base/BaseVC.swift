//
//  BaseController.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit
import SnapKit
import ESPullToRefresh

public class BaseVC: UIViewController {
    ///根据内容切换status bar颜色和navigation bar item的颜色
    var isLightContent: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    ///是否透明导航条，default is true
    var isClearNavigationBar: Bool = true
    
    ///是否隐藏导航条，default is false
    var isNavigationBarHidden = false
    
    ///是否使用默认的自定义返回按钮，default is true
    var isCustomBackButton = true {
        didSet {
            updateBackButton()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit: \(self)")
    }
    
  public  override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .background.main
        
        updateBackButton()
    }
    
    
    ///setupView和setupVM每个controller基本都需要，所以在base里进行调用，懒得在每个子controller写一遍。
    ///但是在base的viewDidLoad方法调用会有一个生命周期的问题，子controller的viewDidLoad还没有执行完成。可能会做一些初始化的操作
    ///所以我在base的viewWillApear调用，用一个属性记录，防止重复调用，解决viewDidLoad生命周期的问题
    private var isSetupCompletion: Bool = false
    private func commonSetup() {
        if isSetupCompletion { return }
        isSetupCompletion = true
        setupView()
        setupVM()
    }
    
    private func updateNavigationBar() {
        if isClearNavigationBar {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }else {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    private func updateItemColor() {
        let color = isLightContent ? UIColor.black : UIColor.white
        //设置title 颜色
        let textAttributes = [NSAttributedString.Key.foregroundColor: color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //设置item颜色
        navigationController?.navigationBar.tintColor = color
    }
    
  public  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commonSetup()

        ///每个单独的子Controller都可以设置状态栏的颜色和item颜色，只需要设置isLightContent
        updateItemColor()
        
        ///每个单独的子Controller都可以设置导航条是否透明，只需要设置isClearNavigationBar
        updateNavigationBar()
        
        ///每个单独的子Controller都可以设置导航条是否隐藏，只需要设置isNavigationBarHidden
        if navigationController?.isNavigationBarHidden != isNavigationBarHidden {
            navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
        }
    }
    
    ///控制状态栏颜色
public   override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLightContent {
            return .darkContent
        }
        return .lightContent
    }
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(frame: .init(x: 0, y: 0, width: 32, height: 32))
        btn.setImage(.init(named: "icon_back"), for: .normal)
        btn.addTarget(self, action: #selector(onBackBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private func updateBackButton() {
        if isCustomBackButton && (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = .init(customView: backBtn)
        }
    }
    
    @objc func onBackBtnClick() {
        navigationController?.popViewController()
    }
    
    func addDimssKeyboardTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTapGestureAction))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
}

///子Cotnroller实现，主要是懒得在子Controller写重复的代码
extension BaseVC {
    @objc func setupView() {}
    @objc func setupVM() {}
}

///单击屏幕隐藏键盘
extension BaseVC: UIGestureRecognizerDelegate {
    @objc func onTapGestureAction() {
        view.endEditing(false)
    }
 public   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //只在点击自己时触发，如button，cell等等不会触发
        if let btn = touch.view as? UIButton, btn.isEnabled == true, btn.isUserInteractionEnabled == true {
            return false
        }
        if let _ = touch.view as? UITableViewCell {
            return false
        }
        if let _ = touch.view?.superview as? UITableViewCell {
            return false
        }
        return true
    }
}

extension UIViewController {
    func pushToUserDetailController(_ userId: Int) {
        ///todo... 跳转到用户详情页
        let detai = ML_HostdetailsViewController(userId: String(userId))
        navigationController?.pushViewController(detai, animated: true)
    }
    
    func modalToTopupController() {
        ///todo... 跳转充值

        let chong = ML_ChongVC()
//        chong.modalPresentationStyle = .fullScreen
        present(chong, animated: true)
//        let vc = UIViewController.topShow()
//        vc?.navigationController?.pushViewController(chong, animated: true)

    }
}
