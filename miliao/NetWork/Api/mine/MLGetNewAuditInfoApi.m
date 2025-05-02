//
//  MLGetNewAuditInfoApi.m
//  miliao
//
//  Created by apple on 2022/11/10.
//

#import "MLGetNewAuditInfoApi.h"
@interface  MLGetNewAuditInfoApi()

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
@implementation MLGetNewAuditInfoApi

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
    return @"/user/getNewAuditInfo";
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
