//
//  MLGetVipPackagesApi.m
//  miliao
//
//  Created by apple on 2022/10/11.
//

#import "MLGetVipPackagesApi.h"
@interface  MLGetVipPackagesApi()

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *idCard;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLGetVipPackagesApi

- (id)initWithtoken:(NSString *)token
               type:(NSString *)type
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/vip/getVipPackages";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"type":self.type
    };
}

@end
