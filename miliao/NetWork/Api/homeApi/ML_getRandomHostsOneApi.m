//
//  ML_getRandomHostsOneApi.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_getRandomHostsOneApi.h"

@interface ML_getRandomHostsOneApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_getRandomHostsOneApi

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
    return @"/host/getRandomHostsOne";
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
