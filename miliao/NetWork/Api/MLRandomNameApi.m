//
//  MLRandomNameApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLRandomNameApi.h"
@interface MLRandomNameApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *thirdId;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLRandomNameApi

- (id)initWithdev:(NSString *)dev
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
            extra:(NSString *)extra{

    if (self = [super init]) {
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
    return @"/login/randomName";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
       
        @"dev":self.dev,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra
     };
}

@end
