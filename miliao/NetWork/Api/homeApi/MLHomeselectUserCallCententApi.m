//
//  MLHomeselectUserCallCententApi.m
//  miliao
//
//  Created by apple on 2022/11/16.
//

#import "MLHomeselectUserCallCententApi.h"
@interface MLHomeselectUserCallCententApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLHomeselectUserCallCententApi

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
    return @"/host/selectUserCallCentent";
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
