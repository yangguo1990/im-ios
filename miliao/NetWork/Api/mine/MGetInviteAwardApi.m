//
//  MGetInviteAwardApi.m
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MGetInviteAwardApi.h"
@interface  MGetInviteAwardApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MGetInviteAwardApi

- (id)initWithtotoken:(NSString *)token
                  page:(NSString *)page
                 limit:(NSString *)limit
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.page = page;
        self.limit = limit;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getInviteAward";
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
        @"limit":self.limit
     };
}

@end
