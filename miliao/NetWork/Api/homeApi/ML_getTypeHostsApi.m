//
//  ML_getTypeHostsApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_getTypeHostsApi.h"
@interface ML_getTypeHostsApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_getTypeHostsApi

- (id)initWithtoken:(NSString *)token
               type:(NSString *)type
               page:(NSString *)page
              limit:(NSString *)limit
           location:(NSString *)location
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.page = page;
        self.limit = limit;
        self.extra = extra;
        self.location = location;
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/getTypeHosts";
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
        @"limit":self.limit,
        @"type":self.type,
        @"location":self.location
     };
}

@end
