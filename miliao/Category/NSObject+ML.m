//
//  UIViewController+LVURLRedirect.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/6/21.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "NSObject+ML.h"
#import "UIViewController+CurrentShowVC.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "UIAlertController+MLBlock.h"
#import "ML_JubaoVC.h"
#import "ML_CommonApi.h"
#import "ML_HostdetailsViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
#import "MLAESUtil.h"
#import "ML_ChongVC.h"
#import "SSKeychain.h"
#import "SiLiaoBack-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import "ML_ChongVCT.h"

@implementation NSObject (ML)
- (void)gotoChongVC
{
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]){
        [[UIViewController topShowViewController].navigationController pushViewController:[ML_ChongVCT new] animated:YES];
    }else{
        [[UIViewController topShowViewController].navigationController pushViewController:[ML_ChongVC new] animated:YES];
    }
    
}
- (void)gotoChatVC:(NSString *)userId
{
    if ([[NSString stringWithFormat:@"%@", userId] isEqualToString:[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]) {
        PNSToast([UIViewController topShowViewController].view, @"不能私信自己", 1.0);
        return;
    }
//    ML_SessionViewController *vc = [[ML_SessionViewController alloc] initWithSession:[NIMSession session:[NSString stringWithFormat:@"%@", userId] type:NIMSessionTypeP2P]];
    IMChatVC *chatvc = [[IMChatVC alloc]initWithUserId:userId.integerValue];
    [[UIViewController topShowViewController].navigationController pushViewController:chatvc animated:YES];
}


- (void)gotoInfoVC:(NSString *)userId
{
    if ([[NSString stringWithFormat:@"%@", userId] isEqualToString:@"10000001"]) {
        return;
    }
    
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

    if (userData.officialInfo) {
        NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
        NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
        
        if ([[NSString stringWithFormat:@"%@", userId] isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]] || [[NSString stringWithFormat:@"%@", userId]  isEqualToString:dic1[@"name"]]) {
            return;
        }
        
    }
    
    
    NSLog(@"userId=== %@", userId);
    ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@", userId]];
    [[UIViewController topShowViewController].navigationController pushViewController:vc animated:YES];
}

- (void)gotoCallVCWithUserId:(NSString *)userId isCalled:(BOOL)isCalled
{
    
    [RTCManager call:userId.integerValue];

}

// 获取唯一标识
- (NSString *)ML_GetUniqueDeviceIdentifierAsString {

    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    NSString *str = [uuid lowercaseString];
    if ([str containsString:@"-"]) {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return str;
    
}

- (void)ML_PopAction:(NSInteger)index pDic:(NSDictionary *)pDic
{
    NSInteger index2 = index + ([pDic[@"showInfo"] boolValue]?0:1);
    
    if (index2 == 0) {
        [self gotoInfoVC:pDic[@"userId"]];
    } else if (index2 == 1) {
        
        [[UIViewController topShowViewController].navigationController pushViewController:[[ML_JubaoVC alloc] initWithWithDic:pDic]  animated:YES];
      
    } else if (index2 == 2) {
        BOOL b = [pDic[@"block"] boolValue];
        ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
        tanV.dic = @{@"type" : @(ML_TanchuangViewType_lahei), @"data" : b?Localized(@"确定要把对方移出黑名单吗?", nil):Localized(@"拉黑后，对方不能再关注你，不能向你发送消息、评论你的动态和作品等", nil), @"pDic" : pDic};
        
    }
    
}

- (void)ML_InfoPopAction:(NSInteger)index pDic:(NSDictionary *)pDic
{
    NSInteger index2 = index + ([pDic[@"showInfo"] boolValue]?0:1);
    
    if (index2 == 0) {
        [self gotoInfoVC:pDic[@"userId"]];
    } else if (index2 == 1) {

            ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
            tanV.dic = @{@"type" : @(ML_TanchuangViewType_lahei), @"data" : Localized(@"拉黑后，对方不能再关注你，不能向你发送消息、评论你的动态和作品等", nil), @"pDic" : pDic};
        
    }
    
}

- (void)imageViewAddClickWithImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAddTap:)]];
}

- (void)imageViewAddTap:(UIGestureRecognizer *)gr
{
    if (gr.view.tag) {
        NSString *userId = [NSString stringWithFormat:@"%ld", gr.view.tag];
        [self gotoInfoVC:userId];
    }
    
}

#pragma mark - 公有方法

//类型识别:将所有的NSNull类型转化成@""
+ (id)changeType:(id)myObj {
    
    if ([myObj isKindOfClass:[NSDictionary class]]) return [self nullDic:myObj];
        
    else if([myObj isKindOfClass:[NSArray class]]) return [self nullArr:myObj];
        
    else if([myObj isKindOfClass:[NSString class]]) return [self stringToString:myObj];
        
    else if([myObj isKindOfClass:[NSNull class]]) return [self nullToString];
        
    else return myObj;
            
}
#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic {
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    
    [myDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
       id Obj = [self changeType:obj];
        
        [resDic setObject:Obj forKey:key];
    }];
    
    return resDic;
    
}
//将NSArray中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr {
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    [myArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
       id Obj = [self changeType:obj];
        
        [resArr addObject:Obj];
    }];
    
    return resArr;

}
//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string{
    
    return string;
    
}
//将Null类型的项目转化成@""
+(NSString *)nullToString {
    
    return @"";
}


-(NSString *)giveformatter{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//     [formatter setDateStyle:NSDateFormatterMediumStyle];
//     [formatter setTimeStyle:NSDateFormatterShortStyle];
//     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
     NSDate *datenow = [NSDate date];
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

// 获取当前系统语言
- (NSString*)getPreferredLanguage
{
//    return @"en";
    
    if (kisCH) {
        return @"zh-Hans";
    }
    
    NSString *preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"];
    
    
    if (!preferredLang) {
        
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        preferredLang = [languages objectAtIndex:0];
        NSLog(@"Preferred Languageferred Language:%@", preferredLang);
        
        if ([preferredLang isEqualToString:@"zh-Hans-CN"]) {
            preferredLang = @"zh-Hans";
        } else if ([preferredLang isEqualToString:@"zh-Hant-HK"]) { // 香港
            preferredLang = @"zh-HK";
        } else if ([preferredLang isEqualToString:@"zh-Hant-TW"]) { // 台湾
            preferredLang = @"zh_TW"; // @"zh-Hant-TW";  @"zh_TW";
        } else if ([preferredLang isEqualToString:@"ar-CN"]) { // 阿拉伯
            preferredLang = @"ar";
        } else if ([preferredLang isEqualToString:@"fil-CN"] || [preferredLang isEqualToString:@"en_PH"]) { // 菲律宾
            preferredLang = @"fil-PH";
        } else if ([preferredLang isEqualToString:@"es-CN"]) { //     西班牙
            preferredLang = @"es";
        } else if ([preferredLang isEqualToString:@"pt-PT"]) { //      葡萄牙
            preferredLang = @"pt-PT";
        } else if ([preferredLang isEqualToString:@"th-CN"]) { //      泰国
            preferredLang = @"th";
        } else if ([preferredLang isEqualToString:@"tr-CN"]) { //       土耳其
            preferredLang = @"tr";
        } else if ([preferredLang isEqualToString:@"vi-CN"]) { //    越南
            preferredLang = @"vi";
        } else if ([preferredLang isEqualToString:@"hi-CN"]) { //     印地语
            preferredLang = @"hi-IN";
        } else if ([preferredLang isEqualToString:@"id-CN"]) { //     印尼
            preferredLang = @"id";
        } else if ([preferredLang isEqualToString:@"ms-CN"]) { //     马来语
            preferredLang = @"ms";
        } else { // 英语
            preferredLang = @"en";
        }
    }
    
    
    return preferredLang;
}
- (NSString *)jsonStringForDictionary{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longstr = @"";
    NSString *latstr = @"";
    if ([defaults objectForKey:@"longstr"]) {
        longstr = [defaults objectForKey:@"longstr"];
    }
    if ([defaults objectForKey:@"latstr"]) {
        latstr = [defaults objectForKey:@"latstr"];
    }
    NSLog(@"%d--i--", [longstr length]);
    
        UIDevice *device = [[UIDevice alloc] init];
//        NSString *name = device.name;       //获取设备所有者的名称
        NSString *name = [self getCurrentDeviceModel];
        NSString *systemName = device.systemName;   //获取当前运行的系统
        NSString *systemVersion = device.systemVersion;//获取当前系统的版本
        NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSString *ppversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dicJson= @{@"sysType":systemName,
                                    @"sysVersion":systemVersion,
                                    @"appVersion":ppversion,
                                    @"phoneType":name,
                                 @"ip":[defaults objectForKey:@"ipaddr"]?:@"",
                                    @"imei":udid,
                                 @"location":[longstr length]?[NSString stringWithFormat:@"%@,%@",longstr, latstr]:@"",
                                    @"platform":@"iOS"};
    
    
    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}


-(NSString *)shaData{
    NSString *apiKey = kML_ApiKey;
    NSString *timeSp = [self giveformatter];
    NSString *numstr = [self numstr];
    NSString *newString = [NSString stringWithFormat:@"%@%@%@", apiKey,numstr,timeSp];
    NSString *ss = [self sha1:newString];
    return ss;
}


- (NSString *) sha1:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

-(NSString *)numstr{
    int num = (arc4random() % 10000);
    NSString *numstr = [NSString stringWithFormat:@"%.4d", num];
    return numstr;
}

- (void)ML_GuanzhuWithUserId:(NSString *)userId btnView:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    
   ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : userId, @"type" : @(btn.selected)} urlStr:@"user/focus"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        
    } error:^(MLNetworkResponse *response) {
        
        btn.selected = !btn.selected;
        
    } failure:^(NSError *error) {
        
        btn.selected = !btn.selected;
    }];
    
}


- (NSString *)getCurrentDeviceModel{
   struct utsname systemInfo;
   uname(&systemInfo);
   
   NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
   
   
if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
// 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
 
if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
 
if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}


//利用正则表达式验证

- (BOOL)isValidateEmail:(NSString *)email {

    if((0 != [email rangeOfString:@"@"].length) &&

    (0 != [email rangeOfString:@"."].length))

    {

    NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];

    NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];

    [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];

    /*

    *使用compare option 来设定比较规则，如

    *NSCaseInsensitiveSearch是不区分大小写

    *NSLiteralSearch 进行完全比较,区分大小写

    *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值

    */

    NSRange range1 = [email rangeOfString:@"@"

    options:NSCaseInsensitiveSearch];

    //取得用户名部分

    NSString* userNameString = [email substringToIndex:range1.location];

    NSArray* userNameArray = [userNameString componentsSeparatedByString:@"."];

    for(NSString* string in userNameArray)

    {

    NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];

    if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])

    return NO;

    }

    //取得域名部分

    NSString *domainString = [email substringFromIndex:range1.location+1];

    NSArray *domainArray = [domainString componentsSeparatedByString:@"."];

    for(NSString *string in domainArray)

    {

    NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];

    if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])

    return NO;

    }

    return YES;

    }

    else {

    return NO;

    }
}


- (void)opentNotificationAlertWithTitle:(NSString *)title
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"无法使%@，前往：\"设置>%@\"中打开%@权限", title, app_Name, title];

    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@权限未开启", title] message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        }
        
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    
    [[UIViewController topShowViewController] presentViewController:alertCon animated:YES completion:^{
        
    }];
    
}

@end
