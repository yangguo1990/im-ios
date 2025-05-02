//
//  MLLogoutApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLLogoutApi.h"
@interface  MLLogoutApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *thirdId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLLogoutApi

- (id)initWithdev:(NSString *)dev
            token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.dev = dev;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/login/logout";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"dev":self.dev,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra
     };
}

@end
