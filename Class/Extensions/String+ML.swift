//
//  String+ML.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/24.
//

import Foundation
import CommonCrypto
import CryptoSwift
import Security

//加密和解密
extension String {
    func aesEncrypt(key: String = Constants.AES.encryptKey, iv: String = Constants.AES.iv) -> String? {
        guard let cipherData = data(using: .utf8) else {
            return nil
        }
        guard let keyData = key.data(using: .utf8), let ivData = iv.data(using: .utf8) else {
            return nil
        }
        do {
            let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
            let encrypted = try aes.encrypt(cipherData.bytes)
            return encrypted.toBase64()
        } catch {
            return nil
        }
    }
        
    func aesDecrypt(key: String = Constants.AES.decryptKey, iv: String = Constants.AES.iv) -> String? {
        guard let cipherData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        guard let keyData = key.data(using: .utf8), let ivData = iv.data(using: .utf8) else {
            return nil
        }
        do {
            let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
            let decrypted = try aes.decrypt(cipherData.bytes)
            return String(bytes: decrypted, encoding: .utf8)
        } catch {
            return nil
        }
        
    }
}

extension String {
    func appendTab() -> String {
        self.appending("\u{0009}")
    }
    func appendSpace() -> String {
        self.appending("\u{0020}")
    }
    func copyToPasteboard() {
        UIPasteboard.general.string = self
        Toast.show("已复制")
    }
}
