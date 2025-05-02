//
//  MLDeletZhaoApi.m
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLDeletZhaoApi.h"
@interface MLDeletZhaoApi()

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *ids;
@property (nonatomic,copy)NSString *extra;


@end
@implementation MLDeletZhaoApi

- (id)initWithids:(NSString *)ids
              token:(NSString *)token
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.ids = ids;
        self.token = token;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/delCallContent";
}



- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"ids":self.ids,
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
