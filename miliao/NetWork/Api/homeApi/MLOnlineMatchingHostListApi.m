//
//  MLOnlineMatchingHostListApi.m
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import "MLOnlineMatchingHostListApi.h"
@interface MLOnlineMatchingHostListApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLOnlineMatchingHostListApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
              limit:(NSString *)limit{

    if (self = [super init]) {
        self.token = token;
        self.limit = limit;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/onlineMatchingList";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"limit":self.limit
    };
}

@end
