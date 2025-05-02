//
//  MLRegisterApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLRegisterApi.h"
@interface MLRegisterApi()

@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSDictionary *thirdId;
@property (nonatomic,copy)NSString *gender;

@property (nonatomic,copy)NSString *birth;
@property (nonatomic,copy)NSString *inviteCode;
@property (nonatomic,copy)NSString *channelCode;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;
@property (nonatomic,copy)NSString *pass;

@end
@implementation MLRegisterApi

- (id)initWithicon:(NSString *)icon
              name:(NSString *)name
           thirdId:(NSDictionary *)thirdId
            gender:(NSString *)gender
             birth:(NSString *)birth
        inviteCode:(NSString *)inviteCode
       channelCode:(NSString *)channelCode
               dev:(NSString *)dev
                nonce:(NSNumber *)nonce
             currTime:(NSString *)currTime
             checkSum:(NSString *)checkSum
              pass:(NSString*)pass
             extra:(NSString *)extra{

    if (self = [super init]) {
        self.icon = icon;
        self.name = name;
        self.thirdId = thirdId;
        self.gender = gender;
        self.birth = birth;
        self.inviteCode = inviteCode;
        self.channelCode = channelCode;
        self.dev = dev;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
        self.extra = extra;
        self.pass = pass;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/login/register";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.thirdId];
    [muDic setObject:self.icon forKey:@"icon"];
    [muDic setObject:self.name forKey:@"name"];
    [muDic setObject:self.gender forKey:@"gender"];
    [muDic setObject:self.birth forKey:@"birth"];
    [muDic setObject:self.inviteCode forKey:@"inviteCode"];
    [muDic setObject:self.channelCode forKey:@"channelCode"];
    [muDic setObject:self.dev forKey:@"dev"];
    [muDic setObject:self.nonce forKey:@"nonce"];
    [muDic setObject:self.currTime forKey:@"currTime"];
    [muDic setObject:self.checkSum forKey:@"checkSum"];
    [muDic setObject:self.extra forKey:@"extra"];
    [muDic setObject:self.pass forKey:@"password"];
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Languageferred Language:%@", preferredLang);

    if ([preferredLang isEqualToString:@"zh_CN"]) {
        preferredLang = @"zh-Hans";
    }  else if ([preferredLang isEqualToString:@"zh_HK"]) { // 香港
        preferredLang = @"zh-HK";
    } else if ([preferredLang isEqualToString:@"zh_TW"]) { // 台湾
        preferredLang = @"zh-Hant-TW";
    } else if ([preferredLang isEqualToString:@"ar_AR"]) { // 阿拉伯
        preferredLang = @"ar";
    } else if ([preferredLang isEqualToString:@"en_PH"]) { // 菲律宾
        preferredLang = @"en_PH";
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

    if (!kisCH) {
        [muDic setObject:preferredLang forKey:@"languageCode"];
    }

    return muDic;
}

////验证返回的数据格式
//-(id)jsonValidator {
//    return @{
//             @"status": [NSString class],
//             @"msg": [NSString class]
//             };
//       }

@end
