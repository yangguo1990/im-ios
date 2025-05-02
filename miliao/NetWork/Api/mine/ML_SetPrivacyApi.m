//
//  ML_SetPrivacyApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SetPrivacyApi.h"
@interface ML_SetPrivacyApi()

@property (nonatomic,copy)NSString *privacy;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_SetPrivacyApi

- (id)initWithprivacy:(NSString *)privacy
             extra:(NSString *)extra
             token:(NSString *)token{

    if (self = [super init]) {
        self.privacy = privacy;
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/setPrivacy";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"privacy":self.privacy,
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
