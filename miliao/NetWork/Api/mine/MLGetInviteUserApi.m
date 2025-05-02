//
//  MLGetInviteUserApi.m
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MLGetInviteUserApi.h"
@interface  MLGetInviteUserApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;
@property (nonatomic,copy)NSString *key;
@end
@implementation MLGetInviteUserApi

- (id)initWithtotoken:(NSString *)token
                  page:(NSString *)page
                limit:(NSString *)limit type:(NSString *)type key:(NSString *)key
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.page = page;
        self.limit = limit;
        self.extra = extra;
        self.type = type;
        self.key = key?:@"";
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getInviteUser";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"page":self.page,
        @"extra":self.extra,
        @"limit":self.limit,
        @"type":self.type,
        @"key":self.key
     };
}

@end
