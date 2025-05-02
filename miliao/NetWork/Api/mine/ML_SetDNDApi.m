//
//  ML_SetDNDApi.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SetDNDApi.h"
@interface ML_SetDNDApi()

@property (nonatomic,copy)NSString *dnd;
@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_SetDNDApi

- (id)initWithdnd:(NSString *)dnd
             extra:(NSString *)extra
             token:(NSString *)token{

    if (self = [super init]) {
        self.dnd = dnd;
        self.extra = extra;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/setDND";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"dnd":self.dnd,
        @"extra":self.extra,
        @"token":self.token
    };
}

@end
