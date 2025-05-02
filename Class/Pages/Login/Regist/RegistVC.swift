//
//  RegistVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/3.
//

import UIKit
import BonMot
import RxSwift

class RegistVC: BaseVC {
    let viewModel: LoginVM
    let thirdId: String
    
    init(viewModel: LoginVM, thirdId: String) {
        self.viewModel = viewModel
        self.thirdId = thirdId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gender: Gender = .male {
        didSet {
            updateGender()
        }
    }
    
    lazy var femaleView: UIView = {
        let view = GradientView()
        view.layerCornerRadius = 12
        view.colors = [.rgb(198, 255, 221), .rgb(251, 215, 134), .rgb(247, 121, 125)]
        view.direction = .h
        
        let img = UIImageView(image: UIImage.init(named: "login_female"))
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(68)
        }
        
        let label = UILabel()
        label.text = "女 ｜ Woman"
        label.textColor = .white
        label.font = .title18
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        let sel = UIImageView(image: UIImage.init(named: "icon_sel"))
        sel.tag = 100
        view.addSubview(sel)
        sel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onFemale)))
        return view
    }()
    
    lazy var maleView: UIView = {
        let view = GradientView()
        view.layerCornerRadius = 12
        view.colors = [.rgb(40, 48, 72), .rgb(133, 147, 152)]
        view.direction = .h
        
        let img = UIImageView(image: UIImage.init(named: "login_male"))
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(68)
        }
        
        let label = UILabel()
        label.text = "男 ｜ Man"
        label.textColor = .white
        label.font = .title18
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        let sel = UIImageView(image: UIImage.init(named: "icon_sel"))
        sel.tag = 100
        view.addSubview(sel)
        sel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onMale)))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGender()
        viewModel.getRandomName()
    }
    
    func updateGender() {
        if gender == .male {
            maleView.viewWithTag(100)?.isHidden = false
            femaleView.viewWithTag(100)?.isHidden = true
        }else {
            maleView.viewWithTag(100)?.isHidden = true
            femaleView.viewWithTag(100)?.isHidden = false
        }
    }
    
    @objc func onMale() {
        gender = .male
    }
    @objc func onFemale() {
        gender = .female
    }
    @objc func onNext() {
        let vc = RegistVC2(viewModel: viewModel, thirdId: thirdId, gener: gender)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistVC {
    override func setupView() {
        super.setupView()
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = .composed(of: [
            "请选择性别？".styled(with: .color(.text.body), .font(.title18)),
            Special.nextLine,
            "我们会帮你找到符合你期望的人".styled(with: .color(.text.describe), .font(.medium14))
        ], baseStyle: StringStyle(.lineSpacing(12), .alignment(.center)))
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
        }
        
        view.addSubview(maleView)
        maleView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        view.addSubview(femaleView)
        femaleView.snp.makeConstraints { make in
            make.top.equalTo(maleView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(maleView)
        }
        
        let nextBtn = UIButton()
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        nextBtn.backgroundColor = .background.orange
        nextBtn.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(50)
        }
        nextBtn.layerCornerRadius = 25
    }
}
