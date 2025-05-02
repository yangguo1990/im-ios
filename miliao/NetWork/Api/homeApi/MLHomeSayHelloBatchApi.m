//
//  MLHomeSayHelloBatchApi.m
//  miliao
//
//  Created by apple on 2022/11/16.
//

#import "MLHomeSayHelloBatchApi.h"

@interface MLHomeSayHelloBatchApi()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *toUserIds;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *contentId;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLHomeSayHelloBatchApi

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
          contentId:(NSString *)contentId
          toUserIds:(NSString *)toUserIds{

    if (self = [super init]) {
        self.token = token;
        self.contentId = contentId;
        self.extra = extra;
        self.toUserIds = toUserIds;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/sayHelloBatch";
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
        @"toUserIds":self.toUserIds
    };
}

@end
