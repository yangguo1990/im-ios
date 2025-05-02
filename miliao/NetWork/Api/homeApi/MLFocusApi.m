//
//  MLFocusApi.m
//  miliao
//
//  Created by apple on 2022/9/23.
//

#import "MLFocusApi.h"
@interface MLFocusApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLFocusApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
           toUserId:(NSString *)toUserId
               type:(NSString *)type{

    if (self = [super init]) {
        self.token = token;
        self.toUserId = toUserId;
        self.extra = extra;
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/focus";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"toUserId":self.toUserId,
        @"type":self.type
     };
}

@end
