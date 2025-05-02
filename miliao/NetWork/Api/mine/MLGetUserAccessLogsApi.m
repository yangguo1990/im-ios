//
//  MLGetUserAccessLogsApi.m
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "MLGetUserAccessLogsApi.h"
@interface  MLGetUserAccessLogsApi()

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLGetUserAccessLogsApi

- (id)initWithtoken:(NSString *)token
                  type:(NSString *)type
                  page:(NSString *)page
                 limit:(NSString *)limit
            extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.type = type;
        self.page = page;
        self.limit = limit;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/getUserAccessLogs";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"page":self.page,
        @"type":self.type,
        @"extra":self.extra,
        @"limit":self.limit
     };
}

@end
