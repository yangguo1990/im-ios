//
//  IMChatSendImageVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/27.
//

import UIKit

protocol IMChatSendImageDelegate: AnyObject {
    func chatSendImgOnSend(_ image: UIImage)
}

class IMChatSendImageVC: BaseVC {
    let image: UIImage
    
    weak var delegate: IMChatSendImageDelegate?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imgView: UIImageView = {
        let img = UIImageView(image: image)
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = .init(title: "取消", style: .done, target: self, action: #selector(onCancel))
        navigationItem.rightBarButtonItem = .init(title: "发送", style: .done, target: self, action: #selector(onSend))
        
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func onCancel() {
        dismiss(animated: true)
    }
    
    @objc func onSend() {
        dismiss(animated: true)
        delegate?.chatSendImgOnSend(image)
    }
}
