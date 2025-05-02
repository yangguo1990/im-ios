//
//  ML_SetLocalApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SetLocalApi.h"
@interface ML_SetLocalApi()

@property (nonatomic,copy)NSString *local;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_SetLocalApi

- (id)initWithlocal:(NSString *)local
             extra:(NSString *)extra
             token:(NSString *)token{

    if (self = [super init]) {
        self.local = local;
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/setLocal";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"local":self.local,
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
