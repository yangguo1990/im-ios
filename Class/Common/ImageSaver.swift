//
//  ImageSaver.swift
//  MeiLiao
//
//  Created by Kun Xun on 2024/2/28.
//

import UIKit
import Photos

class ImageSaver: NSObject {
    func save(_ image: UIImage?) {
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(image:error:contextInfo:)), nil)
    }
    @objc private func saveCompletion(image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            Toast.show("图片保存成功")
        }else {
            Toast.show(error?.localizedDescription ?? "save fail")
        }
    }
}
