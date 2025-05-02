//
//  MLGetUserDynamicApi.m
//  miliao
//
//  Created by apple on 2022/9/22.
//

#import "MLGetUserDynamicApi.h"
@interface MLGetUserDynamicApi()

@property (nonatomic,copy)NSString *token;
//@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,strong)NSNumber *page;

@end
@implementation MLGetUserDynamicApi

- (id)initWithtoken:(NSString *)token
              page:(NSNumber *)page
           toUserId:(NSString *)toUserId{

    if (self = [super init]) {
        self.token = token;
        self.toUserId = toUserId;
        self.page = page;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/getUserDynamic";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra": [self jsonStringForDictionary],
        @"page": self.page,
        @"toUserId":self.toUserId
     };
}

@end
