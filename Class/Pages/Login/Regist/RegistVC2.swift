//
//  RegistVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/3.
//

import UIKit
import BonMot
import RxSwift

class RegistVC2: BaseVC {
    let disposeBag = DisposeBag()
    let viewModel: LoginVM
    let thirdId: String
    let gender: Gender
    
    var image: UIImage? {
        didSet {
            if let image = image {
                avatar.contentMode = .scaleAspectFill
                avatar.image = image
            }
        }
    }
    
    var birthday = Date().adding(.year, value: -20) {
        didSet {
            updateBirthday()
        }
    }
    
    init(viewModel: LoginVM, thirdId: String, gener: Gender) {
        self.viewModel = viewModel
        self.thirdId = thirdId
        self.gender = gener
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var avatar: UIImageView = {
        let img = UIImageView(image: UIImage.init(named: "login_img_add"))
        img.backgroundColor = .white
        img.contentMode = .center
        img.layer.borderColor = UIColor.background.border.cgColor
        img.layer.borderWidth = 1
        return img
    }()
    lazy var avatarContainer: UIView = {
        let view = UIView()
        view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onAvatarTap)))
        return view
    }()
    
    lazy var nameTf: UITextField = {
        let tf = MaxLengthTextField()
        tf.maxLength = 7
        tf.textColor = .text.body
        tf.font = .medium16
        tf.textAlignment = .center
        tf.placeholder = "请输入昵称"
        return tf
    }()
    
    lazy var nameContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_random"), for: .normal)
        btn.addTarget(self, action: #selector(onRandomName), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(50)
        }
        view.addSubview(nameTf)
        nameTf.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
        }
        return view
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onBirthdayTap)))
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton()
        nextBtn.setTitle("注册", for: .normal)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        nextBtn.backgroundColor = .background.orange
        nextBtn.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        return nextBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDimssKeyboardTapGesture()
        navigationItem.title = "完善资料"
        
        updateBirthday()
    }
    func updateName() {
        if let name = viewModel.randomName {
            nameTf.text = name
        }
    }
    func updateBirthday() {
        let space = "      "
        birthdayLabel.attributedText = .composed(of: [
            birthday.year.string.styled(with: .font(.medium16), .color(.text.body)),
            Special.space,
            "年".styled(with: .font(.body16), .color(.text.describe)),
            space,
            birthday.month.string.styled(with: .font(.medium16), .color(.text.body)),
            Special.space,
            "月".styled(with: .font(.body16), .color(.text.describe)),
            space,
            birthday.day.string.styled(with: .font(.medium16), .color(.text.body)),
            Special.space,
            "日".styled(with: .font(.body16), .color(.text.describe))
        ], baseStyle: StringStyle(.alignment(.center)))
    }
    @objc func onRandomName() {
        viewModel.getRandomName()
    }
    @objc func onAvatarTap() {
        pickPhoneImage(isEdit: true) { [weak self] result in
            if let image = result.editImage {
                self?.image = image
            }
        }
    }
    @objc func onBirthdayTap() {
        let vc = MLDatePickerVC()
        vc.date = birthday
        vc.completion = { [weak self] date in
            self?.birthday = date
        }
        presentPanModal(vc)
    }
    @objc func onNext() {
        guard let image = image else {
            avatarContainer.shake()
            Toast.show("请选择头像")
            return
        }
        guard let name = nameTf.text, !name.trimmed.isEmpty else {
            nameContainer.shake()
            Toast.show("请输入昵称")
            return
        }
        ///粘贴板
        let pasteboard = UIPasteboard.general
        var inviteCode = pasteboard.string ?? ""
        ///如果粘贴板内容符合前缀，则截取后缀内容，否则置空
        if inviteCode.hasPrefix("xl:inviteCode:") {
            inviteCode = inviteCode.slice(at: 14)
        }else {
            inviteCode = ""
        }
        
        var params = [String: Any]()
        params["gender"] = gender.rawValue
        params["name"] = name
        params["inviteCode"] = inviteCode
        params["thirdId"] = thirdId
        params["birth"] = birthday.string(withFormat: "YYYY-MM-dd")
//        params["dev"] = ""
//        params["channelCode"] = ""
//        params["languageCode"] = ""
        AliyunOSS.uploadAvatar(image) { [weak self] in
            params["icon"] = $0
            self?.regist(params)
        }
    }
    
    func regist(_ params: [String: Any]) {
        let _ = MLRequest.send(.regist(info: params), type: UserModel.self, disableView: nextBtn).subscribe(onSuccess: {
            if let user = $0 {
                self.loginCenter(user)
            }
        })
    }
    func loginCenter(_ user: UserModel) {
        nextBtn.startRequest()
        UserCenter.login(user) { [weak self] result in
            self?.nextBtn.stopRequest()
            if result == false {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension RegistVC2 {
    override func setupVM() {
        super.setupVM()
        viewModel.randomNameSubject.subscribe(onNext: { [weak self] _ in
            self?.updateName()
        }).disposed(by: disposeBag)
    }
    override func setupView() {
        super.setupView()
        
        let gradient = GradientView()
        gradient.direction = .v
        gradient.colors = [.rgb(201, 214, 255), .rgb(226, 226, 226)]
        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(avatarContainer)
        avatarContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
        }
        avatar.layerCornerRadius = 40
        
        let label = UILabel()
        label.text = "起个好听的名字"
        label.textColor = .text.describe
        label.font = .body12
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(avatarContainer.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(30)
        }
        
        view.addSubview(nameContainer)
        nameContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(label.snp.bottom).offset(12)
            make.height.equalTo(50)
        }
        nameContainer.layerCornerRadius = 25
        
        let label2 = UILabel()
        label2.text = "选择你的生日"
        label2.textColor = .text.describe
        label2.font = .body12
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(nameContainer.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(30)
        }
        view.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(label2.snp.bottom).offset(12)
            make.height.equalTo(50)
        }
        birthdayLabel.layerCornerRadius = 25
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(birthdayLabel.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        nextBtn.layerCornerRadius = 25
    }
}

