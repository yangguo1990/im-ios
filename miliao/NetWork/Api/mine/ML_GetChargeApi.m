//
//  ML_GetChargeApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_GetChargeApi.h"
@interface ML_GetChargeApi()

@property (nonatomic,copy)NSString *thirdId;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_GetChargeApi

- (id)initWithtoken:(NSString *)token
             extra:(NSString *)extra{

    if (self = [super init]) {
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getCharge";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
