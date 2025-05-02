//
//  ML_ObjselectApi.m
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "ML_ObjselectApi.h"
@interface ML_ObjselectApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_ObjselectApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
             gender:(NSString *)gender{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.gender = gender;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/trait/labelList";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"gender":self.gender
     };
}

@end
