//
//  ML_bannerApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_bannerApi.h"

@interface ML_bannerApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_bannerApi

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
    return @"/host/getBanners";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token?:@"",
        @"extra":self.extra?:@""
     };
}

@end
