//
//  ML_SetChargeApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SetChargeApi.h"
@interface ML_SetChargeApi()

@property (nonatomic,copy)NSString *chargeId;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_SetChargeApi

- (id)initWithchargeId:(NSString *)chargeId
             extra:(NSString *)extra
             token:(NSString *)token{

    if (self = [super init]) {
        self.chargeId = chargeId;
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/setCharge";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"chargeId":self.chargeId,
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
