//
//  ML_sayHelloApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_sayHelloApi.h"
@interface ML_sayHelloApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_sayHelloApi

- (id)initWithtoken:(NSString *)token
           toUserId:(NSString *)toUserId
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.toUserId = toUserId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/sayHello";
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
