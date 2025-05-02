//
//  SystemMessageVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/27.
//

import UIKit
import ESPullToRefresh
import RxSwift

class SystemMessageVC: BaseVC {
    let viewModel = SystemMessageVM()
    let disposeBag = DisposeBag()
    
    lazy var list: UITableView = {
        let list = UITableView.init(frame: .zero, style: .plain)
        list.dataSource = self
        list.delegate = self
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 120
        list.separatorStyle = .none
        list.backgroundColor = .clear
        list.register(cellWithClass: SystemMsgCell.self)
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background.container
        navigationItem.title = "官方消息"
        self.isNavigationBarHidden = true
        let backBt = UIButton()
        backBt.setBackgroundImage(UIImage(named: "kaitongBG"), for: .normal)
        view.addSubview(backBt)
        backBt.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalTo(16)
            make.top.equalTo(52)
        }
        backBt.addTarget(self, action: #selector(backbtClick), for: .touchUpInside)
        
        addRefreshControl()
        startPullToRefresh()
    }
    
    @objc func backbtClick(){
        navigationController?.popViewController(animated: true)
    }
    
    override func setupView() {
        super.setupView()
        
        view.addSubview(list)
        list.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SystemMessageVC: RefreshControllerProtocol {
    var r_viewModel: BaseListVM<MLListMessages<SystemMessageModel>> {
        viewModel
    }
    var r_list: UIScrollView {
        list
    }
    var r_disposeBag: DisposeBag {
        disposeBag
    }
}

extension SystemMessageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.datas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withClass: SystemMsgCell.self)
        cell.selectionStyle = .none
        cell.model = viewModel.datas?[row]
        return cell
    }
}
