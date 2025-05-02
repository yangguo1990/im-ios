//
//  MLCodeApi.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLCodeApi.h"

@interface MLCodeApi()

@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLCodeApi

- (id)initWithphone:(NSString *)phone
                 op:(NSString *)op
                dev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.phone = phone;
        self.op = op;
        self.dev = dev;
        self.token = token;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/base/sendCode";
}



- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"op":self.op,
        @"dev":self.dev,
        @"phone":self.phone,
        @"token":self.token,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra
     };
}


@end
