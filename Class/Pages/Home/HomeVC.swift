//
//  HomeVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/26.
//

import UIKit
import RxSwift

class HomeVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UserCenter.logout()
    }
}
