//
//  ML_BeautyConfigApi.m
//  miliao
//
//  Created by apple on 2022/9/13.
//

#import "ML_BeautyConfigApi.h"
@interface ML_BeautyConfigApi()

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
@implementation ML_BeautyConfigApi


- (id)initWithbeautyConfig{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)requestUrl
{
   // return @"/user/saveUserBeautyConfig";
    NSString *str = [NSString stringWithFormat:@"user/saveUserBeautyConfig?token=%@",[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    return str;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
    };
}

//- (id)initWithbeautyConfig:(NSString *)beautyConfig
//             extra:(NSString *)extra
//             token:(NSString *)token
//             userId:(NSString *)userId
//             type:(NSString *)type
//             id:(NSString *)id{
//    if (self = [super init]) {
//        self.id = id;
//        self.extra = extra;
//        self.token = token;
//        self.type = type;
//        self.userId = userId;
//        self.beautyConfig = beautyConfig;
//    }
//    return self;
//}
//
//- (NSString *)requestUrl
//{
//   // return @"/user/saveUserBeautyConfig";
//    NSString *str = [NSString stringWithFormat:@"user/saveUserBeautyConfig?token=%@",[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
//    return str;
//}
//
//- (YTKRequestMethod)requestMethod
//{
//    return YTKRequestMethodPOST;
//}
//
//- (id)requestArgument {
//    return @{
//        @"beautyConfig":self.beautyConfig,
//        @"extra":self.extra,
//        @"token":self.token,
//        @"userId":self.userId,
//        @"id":self.id,
//        @"type":self.type
//    };
//}

@end
