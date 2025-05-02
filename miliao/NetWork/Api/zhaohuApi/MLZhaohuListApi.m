//
//  MLZhaohuListApi.m
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLZhaohuListApi.h"

@interface MLZhaohuListApi()

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLZhaohuListApi

- (id)initWithstatus:(NSString *)status
               limit:(NSString *)limit
                page:(NSString *)page
              token:(NSString *)token
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.status = status;
        self.limit = limit;
        self.page = page;
        self.token = token;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/host/getHostCallContents";
}



- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"status":self.status,
        @"limit":self.limit,
        @"page":self.page,
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
