//
//  HelloAlert.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/3/2.
//

import UIKit
import RxSwift
import AMPopTip

class HelloAlert: BaseVC {
    weak var pop: PopTip?
    let disposeBag = DisposeBag()
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.background.main
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var randomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.body
        label.font = .medium12
        return label
    }()
    
    lazy var arrowImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "msg_arrow_down"))
        return img
    }()
    
    lazy var hiContainer: UIView = {
        let view = UIView()
        view.layerBorderColor = .text.body
        view.layerBorderWidth = 1
        let label = UILabel()
        label.text = "招呼语："
        label.textColor = .background.pink
        label.font = .medium12
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(56)
        }
        
        view.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(12)
        }
        
        view.addSubview(randomLabel)
        randomLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(arrowImg.snp.leading).offset(-8)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onRandom)))
        return view
    }()
    
    lazy var hiBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .background.orange
        btn.setImage(UIImage(named: "msg_love"), for: .normal)
        btn.setTitle("  一键打招呼", for: .normal)
        btn.titleLabel?.font = .medium16
        btn.setTitleColor(.text.body, for: .normal)
        btn.addTarget(self, action: #selector(onHello), for: .touchUpInside)
        return btn
    }()
    
    lazy var refreshBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "msg_refresh"), for: .normal)
        btn.addTarget(self, action: #selector(onRefresh), for: .touchUpInside)
        return btn
    }()
    
    lazy var cycleBg: UIView = {
        let cycleBg = UIView()
        cycleBg.backgroundColor = .background.orange
        return cycleBg
    }()
    
    lazy var list: UITableView = {
        let list = UITableView(frame: .init(x: 0, y: 0, width: hiContainer.width, height: 280), style: .plain)
        list.dataSource = self
        list.delegate = self
        list.rowHeight = 40
        list.showsVerticalScrollIndicator = false
        list.register(cellWithClass: MLTextCell.self)
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        requestData()
        requestRandomText()
    }
    
    private var selectHelloIndex = 0 {
        didSet {
            updateHelloText()
        }
    }
    private var helloList: [IMHelloText]?
    func requestRandomText() {
        MLRequest.send(.getHiText, type: IMHelloTextList.self).subscribe(onSuccess: {
            self.helloList = $0?.hostCallContents
            self.updateHelloText()
        }).disposed(by: disposeBag)
    }
    func updateHelloText() {
        guard let list = helloList else { return }
        randomLabel.text = list[selectHelloIndex].content
    }
    
    private var users: [UserDetailUserInfo]?
    func requestData() {
        MLRequest.send(.onlineMatch, type: MLListUsers.self).subscribe(onSuccess: {
            self.users = $0?.users
            self.updateUsers()
        }).disposed(by: disposeBag)
    }
    
    var icons: [UIImageView] = []
    func updateUsers() {
        icons.forEach{ $0.removeFromSuperview() }
        icons.removeAll()
        ///只处理了最多10个用户，超过10个需要改代码
        guard let users = users, users.count <= 10 else {
            return
        }
        let h = 40.0
        for user in users {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.kf.setImage(with: URL(string: user.avatar))
            img.layerCornerRadius = h / 2
            icons.append(img)
            container.addSubview(img)
        }
        
        var indexs = Array(0...9)
        let center = cycleBg.center
        for img in icons {
            let i = indexs.randomElement()!
            indexs.removeFirst(where: { $0 == i })
            let x = center.x + Double.random(in: -100...100)
            let y = center.y - 112.5 + CGFloat((i * 25))
            img.size = .init(width: h, height: h)
            img.center = .init(x: x, y: y)
        }
    }
    
    
    func setup() {
        view.backgroundColor = UIColor.black.alpha(0.3)
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(500)
        }
        
        let bg = UIImageView(image: UIImage(named: "msg_hi_bg"))
        bg.contentMode = .scaleAspectFill
        container.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let topImg = UIImageView(image: UIImage(named: "msg_hi2"))
        topImg.contentMode = .scaleAspectFit
        container.addSubview(topImg)
        topImg.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "msg_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        container.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        let scaleBg = UIView()
        scaleBg.backgroundColor = .background.orange.alpha(0.2)
        container.addSubview(scaleBg)
        scaleBg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.width.height.equalTo(260)
        }
        scaleBg.layerCornerRadius = 130
        DispatchQueue.main.async {
            scaleBg.startScale(from: 0.8, to: 1.3)
        }
        
        let scaleBg2 = UIView()
        scaleBg2.backgroundColor = .background.orange.alpha(0.5)
        container.addSubview(scaleBg2)
        scaleBg2.snp.makeConstraints { make in
            make.center.equalTo(scaleBg)
            make.width.height.equalTo(200)
        }
        scaleBg2.layerCornerRadius = 100
        DispatchQueue.main.async {
            scaleBg2.startScale(from: 0.8, to: 1.2)
        }
        
        container.addSubview(cycleBg)
        cycleBg.snp.makeConstraints { make in
            make.center.equalTo(scaleBg)
            make.width.height.equalTo(120)
        }
        cycleBg.layerCornerRadius = 60
        
        container.addSubview(hiContainer)
        hiContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(scaleBg.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        hiContainer.layerCornerRadius = 20
        
        container.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { make in
            make.top.equalTo(hiContainer.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(44)
        }
        
        container.addSubview(hiBtn)
        hiBtn.snp.makeConstraints { make in
            make.centerY.equalTo(refreshBtn)
            make.leading.equalTo(hiContainer)
            make.trailing.equalTo(refreshBtn.snp.leading).offset(-16)
            make.height.equalTo(44)
        }
        hiBtn.layerCornerRadius = 22
    }
}

extension HelloAlert {
    @objc func onRandom() {
        let pop = PopTip()
        pop.shouldDismissOnTap = false
        pop.shouldShowMask = true
        pop.bubbleColor = UIColor.background.main
        pop.borderColor = .background.orange
        pop.borderWidth = 1
        pop.cornerRadius = 8
        
        let convertedFrame = hiContainer.superview!.convert(hiContainer.frame, to: view)
        pop.show(customView: list, direction: .up, in: view, from: convertedFrame)
        list.reloadData()
        self.pop = pop
    }
    @objc func onRefresh() {
        requestData()
    }
    @objc func onHello() {
        dismiss(animated: true)
        guard let id = helloList?[selectHelloIndex].id, let ids = users?.map({ $0.userId }) else { return }
        MLRequest.send(.sayHiBatch(contentId: id, toIds: ids))
    }
    @objc func onCancel() {
        dismiss(animated: true)
    }
}

extension HelloAlert: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        helloList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = helloList?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: MLTextCell.self)
        cell.selectionStyle = .none
        cell.nameLabel.text = model?.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectHelloIndex = indexPath.row
        pop?.hide()
    }
}

