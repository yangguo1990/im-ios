//
//  UIViewController+ML.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit

enum Action {
    case cancel(String, VoidBlock?)
    case destructive(String, VoidBlock?)
    case done(String, VoidBlock?)
}

extension UIViewController {
    func alertTextField(title: String? = nil, message: String? = nil, configurationHandler: ((UITextField) -> Void)? = nil, done: @escaping (UITextField?) -> Void) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(title: "取消", style: .cancel, isEnabled: true, handler: nil)
        alertController.addAction(title: "确认", style: .default, isEnabled: true) { (_) in
            let tf = alertController.textFields?.first
            done(tf)
        }
        alertController.addTextField(configurationHandler: configurationHandler)
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String? = nil, message: String? = nil, _ actions: Action...) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            switch action {
            case let .cancel(title, callback):
                alertController.addAction(title: title, style: .cancel, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            case let .destructive(title, callback):
                alertController.addAction(title: title, style: .destructive, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            case let .done(title, callback):
                alertController.addAction(title: title, style: .default, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            }
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func sheet(title: String? = nil, message: String? = nil, _ actions: Action...) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            switch action {
            case let .cancel(title, callback):
                alertController.addAction(title: title, style: .cancel, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            case let .destructive(title, callback):
                alertController.addAction(title: title, style: .destructive, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            case let .done(title, callback):
                alertController.addAction(title: title, style: .default, isEnabled: true) { (_) in
                    if let call = callback {
                        call()
                    }
                }
            }
        }
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func openSetting(_ msg: String?) {
        alert(title: "开启权限", message: msg, .cancel("取消", nil), .done("确定", {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
    }
}

//选择照片
typealias ImagePickResult = (image: UIImage?, editImage: UIImage?)
var kImagePickCompletion: ((ImagePickResult) -> Void)?
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func pickPhoneImage(isEdit: Bool = false, completion: @escaping (ImagePickResult) -> Void) {
        kImagePickCompletion = completion
        sheet(title: "选择照片", .done("拍照", {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = .camera
            vc.allowsEditing = isEdit
            self.present(vc, animated: true)
        }), .done("相册", {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = isEdit
            self.present(vc, animated: true)
        }), .cancel("取消", nil))
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        picker.dismiss(animated: true)
        kImagePickCompletion?((image, editImage))
        kImagePickCompletion = nil
    }
}

extension UIViewController {
    var specificTopController: UIViewController {
        specificTopController(self)
    }
    
    func specificTopController(_ controller: UIViewController?) -> UIViewController {
        guard let controller = controller else {
            return self
        }
        if let tabvc = controller as? UITabBarController {
            return specificTopController(tabvc.selectedViewController)
        }
        if let navc = controller as? UINavigationController {
            return specificTopController(navc.topViewController)
        }
        return controller
    }
}


extension UIViewController {
    /// 从聊天页面弹出礼物
    @objc func presentGiftBy(chat: IMChatVM) {
        let vc = GiftVC()
        vc.chatViewModel = chat
        presentPanModal(vc)
    }
    
    /// 从用户页面弹出礼物
    @objc func presentGiftBy(userId: Int) {
        let vc = GiftVC()
        vc.userId = userId
        presentPanModal(vc)
    }
}
