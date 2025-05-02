//
//  ML_NewestVersionApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_NewestVersionApi.h"
@interface ML_NewestVersionApi()

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
@implementation ML_NewestVersionApi

- (id)initWithtype:(NSString *)type
             extra:(NSString *)extra
             token:(NSString *)token{

    if (self = [super init]) {
        self.type = type;
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/base/getNewestVersion";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"type":self.type,
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
