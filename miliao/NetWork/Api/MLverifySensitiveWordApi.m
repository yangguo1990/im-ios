//
//  MLverifySensitiveWordApi.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLverifySensitiveWordApi.h"
@interface MLverifySensitiveWordApi()

@property (nonatomic,copy)NSString *list;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;

@end
@implementation MLverifySensitiveWordApi

- (id)initWithlist:(NSString *)list
                dev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum{

    if (self = [super init]) {
        self.list = list;
        self.dev = dev;
        self.token = token;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/base/verifySensitiveWord";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"list":self.list,
        @"dev":self.dev,
        @"token":self.token,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum
     };
}

@end
