//
//  ML_CancelBlackApi.m
//  miliao
//
//  Created by apple on 2022/9/7.
//

#import "ML_CancelBlackApi.h"
@interface ML_CancelBlackApi()

@property (nonatomic,copy)NSString *block;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation ML_CancelBlackApi

- (id)initWithblock:(NSString *)block
             extra:(NSString *)extra
             token:(NSString *)token
          toUserId:(NSString *)toUserId{

    if (self = [super init]) {
        self.block = block;
        self.extra = extra;
        self.token = token;
        self.toUserId = toUserId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/im/block";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"block":self.block,
        @"extra":self.extra,
        @"token":self.token,
        @"toUserId":self.toUserId
    };
}

@end
