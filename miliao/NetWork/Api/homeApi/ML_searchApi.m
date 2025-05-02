//
//  ML_searchApi.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_searchApi.h"
@interface ML_searchApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *keyword;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_searchApi

- (id)initWithkeyword:(NSString *)keyword type:(NSString *)type
                 page:(NSString *)page
                limit:(NSString *)limit
                extra:(NSString *)extra
                token:(NSString *)token{

    if (self = [super init]) {
        self.keyword = keyword;
        self.extra = extra;
        self.type = type;
        self.page = page;
        self.limit = limit;
        self.token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/search";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"keyword":self.keyword,
        @"extra":self.extra,
        @"page":self.page,
        @"limit":self.limit,
        @"token":self.token,
        @"type":self.type
     };
}

@end
