//
//  AliyunOSS.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/2/4.
//

import UIKit
import AliyunOSSiOS

struct OSSTokenSTS: Codable {
    let sts: OSSTokenModel
}
struct OSSTokenModel: Codable {
    let accessKeyId: String
    let securityToken: String
    let bucketName: String
    let accessKeySecret: String
    let endpoint: String
}

class AliyunOSS {
    private init() { }
    static let share = AliyunOSS()
    private var client: OSSClient?
}

extension AliyunOSS {
    static func uploadAvatar(_ image: UIImage, failure: @escaping VoidBlock = {}, success: @escaping StringBlock) {
        var fileName = UUID().uuidString + "_avtar.jpg"
        if let uid = UserCenter.share.userModel?.user.id {
            fileName = "\(uid)" + "_avtar.jpg"
        }
        Toast.showHUD()
        let _ = MLRequest.send(.getOssToken(fileName: fileName), type: OSSTokenSTS.self).subscribe(onSuccess: {
            if let token = $0 {
                self.upload(image, fileName: fileName, token: token.sts, failure: failure, success: success)
            }else {
                Toast.hideHUD()
            }
        }, onFailure: { _ in
            Toast.hideHUD()
        })
    }
    
    private static func upload(_ image: UIImage, fileName: String, token: OSSTokenModel, failure: @escaping VoidBlock = {}, success: @escaping StringBlock) {
        guard let data = compressionImage(image) else { return }
        let provider = OSSStsTokenCredentialProvider.init(accessKeyId: token.accessKeyId, secretKeyId: token.accessKeySecret, securityToken: token.securityToken)
        let request = OSSPutObjectRequest()
        request.uploadingData = data
        request.bucketName = token.bucketName
        request.objectKey = fileName
        let endPoint = token.endpoint
        share.client = OSSClient(endpoint: endPoint, credentialProvider: provider)
        let task = share.client?.putObject(request)
        task?.continue({ result in
            DispatchQueue.main.async {
                if let error = result.error {
                    ddPrint((error as NSError).description)
                    failure()
                    Toast.show("上传图片失败")
                }else {
                    success(fileName)
                }
                Toast.hideHUD()
            }
            return nil
        })
    }
    
    ///压缩图
    private static func compressionImage(_ image: UIImage?) -> Data? {
        guard let image = image else {
            return nil
        }
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        
        //小于1M不压缩
        if data.count < 1 * 1024 * 1024 {
            return data
        }
        
        //按一定的比例压缩（根据图片大小动态设置压缩比例）
        let m = CGFloat(data.count) / CGFloat((1024*1024))
        let expectSize = 1.0 + (m * 0.3)
        let quality = min(expectSize / m, 1)
        return image.jpegData(compressionQuality: quality)
    }
}
