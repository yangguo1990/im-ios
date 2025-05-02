//
//  MLHostcallUserApi.m
//  miliao
//
//  Created by apple on 2022/10/19.
//

#import "MLHostcallUserApi.h"
@interface MLHostcallUserApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *contentId;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *operationLogId;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLHostcallUserApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
     operationLogId:(NSString *)operationLogId
          contentId:(NSString *)contentId
          toUserId:(NSString *)toUserId{

    if (self = [super init]) {
        self.token = token;
        self.contentId = contentId;
        self.extra = extra;
        self.operationLogId = operationLogId;
        self.toUserId = toUserId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/callUser";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"contentId":self.contentId,
        @"operationLogId":self.operationLogId,
        @"toUserId":self.toUserId
     };
}

@end
