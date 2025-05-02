//
//  MLDelDynamicApi.m
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLDelDynamicApi.h"
@interface  MLDelDynamicApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *dynamicId;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLDelDynamicApi

- (id)initWithtotoken:(NSString *)token
            dynamicId:(NSString *)dynamicId
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.dynamicId = dynamicId;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/dynamic/delDynamic";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"dynamicId":self.dynamicId,
        @"extra":self.extra
    };
}

@end
