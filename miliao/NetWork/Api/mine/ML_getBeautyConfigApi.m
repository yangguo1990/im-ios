//
//  ML_getBeautyConfigApi.m
//  miliao
//
//  Created by apple on 2022/9/13.
//

#import "ML_getBeautyConfigApi.h"
@interface ML_getBeautyConfigApi()

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *beautyConfig;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_getBeautyConfigApi

- (id)initWithextra:(NSString *)extra
             token:(NSString *)token
             type:(NSString *)type{
    
    if (self = [super init]) {
        self.extra = extra;
        self.token = token;
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getUserBeautyConfig";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"extra":self.extra,
        @"token":self.token,
        @"type":self.type
    };
}

@end
