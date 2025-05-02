//
//  ML_getUserOperationsApi.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_getUserOperationsApi.h"
@interface ML_getUserOperationsApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_getUserOperationsApi

- (id)initWithtoken:(NSString *)token
                 page:(NSString *)page
                limit:(NSString *)limit
                extra:(NSString *)extra{

    if (self = [super init]) {
        self.extra = extra;
        self.page = page;
        self.limit = limit;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/getUserOperations";
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

