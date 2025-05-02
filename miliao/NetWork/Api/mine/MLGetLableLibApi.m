//
//  MLGetLableLibApi.m
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLGetLableLibApi.h"
@interface  MLGetLableLibApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *host;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLGetLableLibApi

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra
               host:(NSString *)host{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.host = host;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getLableLib";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"host":self.host
     };
}

@end
