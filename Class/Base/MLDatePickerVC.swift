//
//  MLDatePickerVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/4.
//

import UIKit
import PanModal

class MLDatePickerVC: BaseVC {
    var completion: ((Date) -> Void)?
    var date: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        // 创建日期选择器
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // 设置日期选择器的显示模式
        datePicker.datePickerMode = .date
        
        // 设置日期选择器的本地化
        datePicker.locale = Locale(identifier: "zh_CN")
        
        // 设置日期选择器的最小日期和最大日期（可选）
        if let date = date {
            datePicker.date = date
        }
        // datePicker.minimumDate = Date()
         datePicker.maximumDate = Date()
        
        // 添加日期选择器的值改变事件监听
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        // 添加日期选择器到视图
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
    
        let nextBtn = UIButton()
        nextBtn.setTitle("确定", for: .normal)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        nextBtn.backgroundColor = .background.orange
        nextBtn.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(datePicker.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        nextBtn.layerCornerRadius = 25
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    @objc func onConfirm() {
        if let date = date {
            completion?(date)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension MLDatePickerVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(400)
    }
}
