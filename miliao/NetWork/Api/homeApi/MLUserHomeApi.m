//
//  MLUserHomeApi.m
//  miliao
//
//  Created by apple on 2022/9/22.
//

#import "MLUserHomeApi.h"
@interface MLUserHomeApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLUserHomeApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
           toUserId:(NSString *)toUserId{

    if (self = [super init]) {
        self.token = token;
        self.toUserId = toUserId;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/getUserHome";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"toUserId":self.toUserId
     };
}

@end
