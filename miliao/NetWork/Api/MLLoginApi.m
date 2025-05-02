//
//  MLLoginApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLLoginApi.h"
@interface MLLoginApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *thirdId;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *yiToken;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;
@end
@implementation MLLoginApi

- (id)initWithtype:(NSString *)type
           thirdId:(NSString *)thirdId
       accessToken:(NSString *)accessToken
              code:(NSString *)code
               dev:(NSString *)dev
           yiToken:(NSString *)yiToken
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
             extra:(NSString *)extra{

    if (self = [super init]) {
        self.type = type;
        self.thirdId = thirdId;
        self.accessToken = accessToken;
        self.code = code;
        self.dev = dev;
        self.yiToken = yiToken;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/login/login";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"type":self.type,
        @"thirdId":self.thirdId,
        @"code":self.code,
        @"dev":self.dev,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra
    }];

    if ([self.type intValue] == 1) {
        [muDic setObject:self.yiToken forKey:@"yiToken"];
    } else if ([self.type intValue] == 2) {
        [muDic setObject:self.yiToken forKey:@"googleToken"];
    } else if ([self.type intValue] == 3) {
        [muDic setObject:self.yiToken forKey:@"faceboookToken"];
        [muDic setObject:@"" forKey:@"facebookUserId"];
    }
    
    if (self.accessToken) {
        [muDic setObject:self.accessToken forKey:@"accessToken"];
    }
    
    if (self.facebookUserId) {
        [muDic setObject:self.facebookUserId forKey:@"facebookUserId"];
    }
    
    return muDic;
}

@end
