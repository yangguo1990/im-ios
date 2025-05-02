//
//  ML_ForyouApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_ForyouApi.h"
@interface ML_ForyouApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_ForyouApi

- (id)initWithtoken:(NSString *)token
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
    return @"/host/getTitleHosts";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"page":self.page,
        @"limit":self.limit
     };
}

@end
