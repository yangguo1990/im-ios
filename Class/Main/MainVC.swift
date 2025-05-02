//
//  ViewController.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit
import RxSwift

enum Tabs {
    case home
    case discover
    case rank
    case message
    case mine
    
    var name: String {
        switch self {
        case .home:
            return "首页"
        case .discover:
            return "社区"
        case .rank:
            return "榜单"
        case .message:
            return "消息"
        case .mine:
            return "我的"
        }
    }
    
    var image: String {
        switch self {
        case .home:
            return "tab1"
        case .discover:
            return "tab2"
        case .rank:
            return "tab3"
        case .message:
            return "tab4"
        case .mine:
            return "tab5"
        }
    }
    var selectedImage: String {
        switch self {
        case .home:
            return "tab1_s"
        case .discover:
            return "tab2_s"
        case .rank:
            return "tab3_s"
        case .message:
            return "tab4_s"
        case .mine:
            return "tab5_s"
        }
    }
}

class MainVC: UITabBarController {
    let disposeBag = DisposeBag()
    lazy var home: BaseNavigationVC = {
        createController(.home, controller: HomeVC())
    }()
    lazy var discover: BaseNavigationVC = {
        createController(.discover, controller: DiscoverVC())
    }()
    lazy var rank: BaseNavigationVC = {
        createController(.rank, controller: RankVC())
    }()
    lazy var message: BaseNavigationVC = {
        createController(.message, controller: MessageVC())
    }()
    lazy var mine: BaseNavigationVC = {
        createController(.mine, controller: MineVC())
    }()
    
    var selectNavc: UINavigationController {
        selectedViewController as! BaseNavigationVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [home, discover, rank, message, mine]
        ///bar item color
        tabBar.tintColor = .black
        ///bar background color
        tabBar.barTintColor = .background.main
    }
    
    func createController(_ tab: Tabs, controller: UIViewController) -> BaseNavigationVC {
        let navc = BaseNavigationVC.init(rootViewController: controller)
        navc.tabBarItem = .init(title: tab.name, image: UIImage.init(named: tab.image)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: tab.selectedImage)?.withRenderingMode(.alwaysOriginal))
        return navc
    }
}

