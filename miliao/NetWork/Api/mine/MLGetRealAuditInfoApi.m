//
//  MLGetRealAuditInfoApi.m
//  miliao
//
//  Created by apple on 2022/10/11.
//

#import "MLGetRealAuditInfoApi.h"
@interface  MLGetRealAuditInfoApi()

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *idCard;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *host;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLGetRealAuditInfoApi

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getRealAuditInfo";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra
    };
}

@end
