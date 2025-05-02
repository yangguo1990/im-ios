//
//  Constants.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/21.
//

import UIKit

func ddPrint(_ item: @autoclosure () -> Any?) {
    #if DEBUG
    print(item() ?? "")
    #endif
}

typealias ArrayBlock<T> = (Array<T>) -> Void
typealias ObjBlock<T> = (T) -> Void
typealias VoidBlock = () -> Void
typealias IndexBlock = (Int) -> Void
typealias BoolBlock = (Bool) -> Void
typealias StringBlock = (String) -> Void

enum ENV {
    case debug  //测试环境
    case release //正式环境
}

struct Constants {
//    static let env: ENV = .debug
    static let env: ENV = .release
    
    //分页初始page
    static let firtPage = 1
    static let pageSize = 20
    
    ///客服微信号
    static let serviceWechatId = "weiweiouni850"
    
    struct im {
        static let appKey = "1174250325225521#app1"//"1100231227212420#s04" //"1100231227212420#im"
        ///官方消息
        static let messageId = "im1000000"
        ///官方客服
        static let serviceId = "im100000"
        ///通话消息
        static let callEvent = "VIDEO"
        ///礼物消息
        static let giftEvent = "GIFT"
        static let giftDataKey = "GiftInfo"
    }
    struct rtc {
        static let appId = "1fb31c3e0253492c94b136a0889d4654"//"0b5a09a7e8a6429a98e1f91d6c29d9fd"
        static let defaultRoomId = "*"
    }
    
    struct url {
        ///api
        static var base: String = {
            if env == .debug {
                return "http://api.tt-bd6.com"
            }else {
                return ML_AppUserInfoManager.shared().hostip//"https://api.tvesfvjm.xyz"
            }
        }()
        ///用户协议
        static let yhxy = "https://www.baidu.com"
        ///隐私政策
        static let yszc = "https://www.jd.com"
        ///移动认证服务条款
        static let ydrz = "https://www.taobao.com"
    }
    
    struct string {
        static let yhxy = "《用户协议》"
        static let yszc = "《隐私政策》"
        static let agreeString = "登录即同意\(yhxy)\(yszc)并授权\(Constants.app.name)获取本机号码"
        
        static let ydrz = "《移动认证服务条款》"
        static let agreeTip = "\(app.name)重视并致力于保障您的个人隐私，我们根据监管要求更新了\(yhxy)和\(yszc)，特别说明如下：\n1.为更好的帮您找到心仪的朋友，会根据您设置的择偶条件向您做推荐;\n2.为了查看附近的用户，我们需要使用您的位置信息，您可以随时开启或关闭此项授权;\n3.您可以随时访问、更正、删除您的个人信息，我们也提供了注销和反馈的渠道;\n4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息;\n5.点击同意即表示您已阅读并同意全部条款。\n我们非常重视您的个人信息保护。关于个人信息收集和使用的详细信息，你可以点击\(ydrz)\(yhxy)和\(yszc)进行了解。"
    }
    
    struct AES {
        static let iv = "A-16-Byte-String"
        static var decryptKey: String = {
            if env == .debug {
                return "ca2c8cd276314de3a00d8368bd7a9989"
            }else {
                return "40ef07e3fb408c8249717b797fe09b75"
            }
        }()
        static var encryptKey: String = {
            if env == .debug {
                return "e6c9d18c6e253d8c8320f1c15b63516e"
            }else {
                return "ecc8360d6c32c1d25c64700d464bbf24"
            }
        }()
    }
    
    //通知
    struct notify {
        static let login = Notification.Name("kNotification.login")
        static let logout = Notification.Name("kNotification.logout")
    }
    
    struct app {
        static var name: String = {
            let infoDictionary = Bundle.main.infoDictionary!
            let appName = infoDictionary["CFBundleDisplayName"] as? String
            return appName ?? ""
        }()
        
        static var version: String = {
            let infoDictionary = Bundle.main.infoDictionary!
            let appVersion = infoDictionary["CFBundleShortVersionString"] as? String
            return appVersion ?? "1.0.0"
        }()
    }
    
    struct device {
        static let systemVersion = UIDevice.current.systemVersion
        static let systemName = UIDevice.current.systemName
        static let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        
        static let model: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }()
        
        static var ipAdrress: String? = {
            var addresses = [String]()
            var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while (ptr != nil) {
                    let flags = Int32(ptr!.pointee.ifa_flags)
                    var addr = ptr!.pointee.ifa_addr.pointee
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8:hostname) {
                                    addresses.append(address)
                                }
                            }
                        }
                    }
                    ptr = ptr!.pointee.ifa_next
                }
                freeifaddrs(ifaddr)
            }
            return addresses.first
        }()
    }
    
    //偏好设置
    struct userDefualt {
        static let user = "userDefault.key.user"
        static let longitude = "userDefault.key.longitude"
        static let latitude = "userDefault.key.latitude"
    }
    
    struct tag {
        static let empty = 2000
        static let loading = 2001
        static let badge = 2002
        static let imPop = 2003
        static let giftPlayer = 2004
    }
    
    static let emotions = [
        "😀","😁","😂","😃","😄","😅","😆","😉","😊","😋","😎","😍","😘","😗","😙","😚",
        "😇","😐","😑","😶","😏","😣","😥","😮","😯","😪","😫","😴","😌","😛","😜","😝","😒",
        "😓","😔","😕","😲","😷","😖","😞","😟","😤","😢","😭","😦","😧","😨","😬","😰","😱",
        "😳","😵","😡","😠","💘","❤","💓","💔","💕","💖","💗","💙","💚","💛","💜","💝","💞","💟",
        "❣","💪","👈","👉","☝","👆","👇","✌","✋","👌","👍","👎","✊","👊","👋","👏","👐","✍","🍇",
        "🍈","🍉","🍊","🍋","🍌","🍍","🍎","🍏","🍐","🍑","🍒","🍓","🍅","🍆","🌽","🍄","🌰","🍞",
        "🍖","🍗","🍔","🍟","🍕","🍳","🍲","🍱","🍘","🍙","🍚","🍛","🍜","🍝","🍠","🍢","🍣","🍤",
        "🍥","🍡","🍦","🍧","🍨","🍩","🍪","🎂","🍰","🍫","🍬","🍭","🍮","🍯","🍼","☕","🍵","🍶","🍷",
        "🍸","🍹","🍺","🍻","🍴","🌹","🍀","🍎","💰","📱","🌙","🍁","🍂","🍃","🌷","💎","🔪","🔫","🏀",
        "⚽","⚡","👄","👍","🔥","🙈","🙉","🙊","🐵","🐒","🐶","🐕","🐩","🐺","🐱","😺","😸","😹","😻","😼",
        "😽","🙀","😿","😾","🐈","🐯","🐅","🐆","🐴","🐎","🐮","🐂","🐃","🐄","🐷","🐖","🐗","🐽","🐏","🐑",
        "🐐","🐪","🐫","🐘","🐭","🐁","🐀","🐹","🐰","🐇","🐻","🐨","🐼","🐾","🐔","🐓","🐣","🐤","🐥","🐦",
        "🐧","🐸","🐊","🐢","🐍","🐲","🐉","🐳","🐋","🐬","🐟","🐠","🐡","🐙","🐚","🐌","🐛","🐜","🐝","🐞","🦋",
        "😈","👿","👹","👺","💀","☠","👻","👽","👾","💣", "🛟", "🛞","⚓","🛬", "🪂","⌚", "⏳", "⏰","🧳","🛰","🚁"
       ]
}
