//
//  UserInfoManager.m
//  LiveVideo
//
//  Created by 林必义 on 2017/4/23.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import "ML_AppUserInfoManager.h"
#import "NTESFileLocationHelper.h"
#import "SkyEyeFucatorUtil.h"

#define LVAccount      @"account"
#define LVToken        @"token"
#define LVGender       @"gender"
#define LVAvatarUrl    @"avtarUrl"
#define LVSetInfo      @"setInfo"
#define LVPassword     @"password"
#define LVDeviceToken  @"deviceToken"
#define LVGoldCoin     @"goldCoin"
#define LVNickName     @"nickName"
#define LVBirthDay     @"birthday"
#define LVVideoVerified @"videoVerified"
#define LVTuHaoDic         @"tuhaoDic"
#define LVSignText      @"signtext"
#define LVCharmDic        @"charmDic"
#define LVUserName     @"userName"
#define LVVideoRate    @"videoRate"
#define LVVipType      @"vipType"
#define LVNeedBind     @"needBind"
#define LVAudioRate    @"audioRate"
#define LVVidoVeryTip  @"videoVeryTip"

@interface UserInfoData ()<NSCoding>

@end

@implementation UserInfoData

- (NSDictionary *)getAllPropertyAndValues
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int count;
   //获取属性列表
    objc_property_t *properties = class_copyPropertyList([UserInfoData class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
       //获取属性值
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
      
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    //释放
    free(properties);
    
    return props;
}





+ (NSDictionary *) mj_replacedKeyFromPropertyName
{
    return @{@"userId" : @"id"};
}

- (NSString *)token
{
    return _token?:@"";
}

- (NSString *)domain
{
    if ([_domain isKindOfClass:[NSString class]] && ![_domain isKindOfClass:[NSNull class]] && [_domain length]) {
        return _domain;
    } else {
        return kHttpIcon;
    }
}

- (NSString *)coin
{
    if (!_coin || [_coin intValue] <= 0) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld", [_coin integerValue]];
}

- (NSString *)credit
{
    if (!_credit || [_credit intValue] <= 0) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld", [_credit integerValue]];
}

- (NSString *)alipay
{
    return  @"1";
}

- (NSString *)wxPay
{
    if (![ML_AppUtil isCensor]) {
        return @"0";
    }
    return _wxPay;
}



@synthesize languageCode = _languageCode;

- (void)setLanguageCode:(NSString *)languageCode
{
    if (kisCH) {
        _languageCode = @"zh-Hans";
        [[NSUserDefaults standardUserDefaults] setObject:@"zh_CN" forKey:@"Bendiyuyan"];
    } else {
        NSString *preferredLang = languageCode;
        [[NSUserDefaults standardUserDefaults] setObject:preferredLang forKey:@"Bendiyuyan"];
        if ([preferredLang isEqualToString:@"zh_CN"]) {
            preferredLang = @"zh-Hans";
        }  else if ([preferredLang isEqualToString:@"zh_HK"]) { // 香港
            preferredLang = @"zh-HK";
        } else if ([preferredLang isEqualToString:@"zh_TW"]) { // 台湾
            preferredLang = @"zh-Hant-TW";
        } else if ([preferredLang isEqualToString:@"ar_AR"]) { // 阿拉伯
            preferredLang = @"ar";
        } else if ([preferredLang isEqualToString:@"en_PH"]) { // 菲律宾
            preferredLang = @"fil-PH";
        } else if ([preferredLang isEqualToString:@"es_ES"]) { //     西班牙
            preferredLang = @"es";
        } else if ([preferredLang isEqualToString:@"pt_PT"]) { //      葡萄牙
            preferredLang = @"pt-PT";
        } else if ([preferredLang isEqualToString:@"th_TH"]) { //      泰国
            preferredLang = @"th";
        } else if ([preferredLang isEqualToString:@"tr_TR"]) { //       土耳其
            preferredLang = @"tr";
        } else if ([preferredLang isEqualToString:@"vi_VN"]) { //    越南
            preferredLang = @"vi";
        } else if ([preferredLang isEqualToString:@"hi_IN"]) { //     印地语
            preferredLang = @"id";
        } else if ([preferredLang isEqualToString:@"in_ID"]) { //     印尼
            preferredLang = @"hi-IN";
        } else if ([preferredLang isEqualToString:@"ms_MY"]) { //     马来语
            preferredLang = @"ms";
        }else {
            preferredLang = @"en";
        }
        _languageCode = preferredLang;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_languageCode forKey:@"currentLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)languageCode
{
    if (!_languageCode) {
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString *preferredLang = [languages objectAtIndex:0];
        NSLog(@"Preferred Languageferred Language:%@", preferredLang);
    
        if ([preferredLang isEqualToString:@"zh-Hans-CN"]) {
            preferredLang = @"zh-Hans";
        } else if ([preferredLang isEqualToString:@"zh-Hant-HK"]) { // 香港
            preferredLang = @"zh-Hant-TW"; // @"zh-HK";
        } else if ([preferredLang isEqualToString:@"zh-Hant-TW"]) { // 台湾
            preferredLang = @"zh_TW";
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
        return preferredLang;
    } else {
        
        if ([_languageCode isEqualToString:@"en_PH"]) {
            return @"fil-PH";
        }
        
        return _languageCode;
    }
}

MJExtensionCodingImplementation

@end

@interface ML_AppUserInfoManager ()
@property (nonatomic,copy)  NSString    *filepath;
@end

@implementation ML_AppUserInfoManager
+ (void)shuaWithCoin:(NSString *)coin
{
    if ([coin intValue]) {
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        currentData.coin = [NSString stringWithFormat:@"%ld", ([currentData.coin integerValue] - [coin integerValue])];
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
    }
//    else {
//        // 通过接口更新
//        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/getGifts"];
//        kSelf;
//        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
//
//            UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//            
//            currentData.coin = [NSString stringWithFormat:@"%@", response.data[@"coin"]];
//
//            [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
//            
//            
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaGiftCion" object:nil];
//            
//        } error:^(MLNetworkResponse *response) {
//
//        } failure:^(NSError *error) {
//            
//        }];
//    }

}

+ (instancetype)sharedManager
{
    static ML_AppUserInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filepath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:@".lv_user_login_data"];
        instance = [[ML_AppUserInfoManager alloc] initWithPath:filepath];
    });
    return instance;
}


- (instancetype)initWithPath:(NSString *)filepath
{
    if (self = [super init])
    {
        _filepath = filepath;
        [self readData];
    }
    return self;
}


- (void)setCurrentLoginUserData:(UserInfoData *)currentLoginData
{
    @synchronized (self) {
        _currentLoginUserData = currentLoginData;
        [self saveData];
    }
}

- (void)readData
{
    NSString *filepath = [self filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        @try {
            NSData * data = [NSData dataWithContentsOfFile:filepath];
            if(data.length){
                data = SkyEyeUtil->deodeDataWithXor(data);
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                _currentLoginUserData = [object isKindOfClass:[UserInfoData class]] ? object : nil;
            }
           
        } @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
       
    }
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentLoginUserData)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginUserData];
        if(data.length){
            data = SkyEyeUtil->deodeDataWithXor(data);
        }
    }
    [data writeToFile:[self filepath] atomically:YES];
}


@end
