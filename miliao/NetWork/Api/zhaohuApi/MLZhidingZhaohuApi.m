//
//  MLZhidingZhaohuApi.m
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLZhidingZhaohuApi.h"
@interface MLZhidingZhaohuApi()

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *contentId;
@property (nonatomic,copy)NSString *ids;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLZhidingZhaohuApi

- (id)initWithcontentId:(NSString *)contentId
              token:(NSString *)token
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.contentId = contentId;
        self.token = token;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/topCallContent";
}



- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"contentId":self.contentId,
        @"token":self.token,
        @"extra":self.extra
     };
}

////验证返回的数据格式
//-(id)jsonValidator {
//    return @{
//             @"status": [NSString class],
//             @"msg": [NSString class]
//             };
//       }

@end
