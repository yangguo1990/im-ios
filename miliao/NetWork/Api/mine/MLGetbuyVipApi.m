//
//  MLGetbuyVipApi.m
//  miliao
//
//  Created by apple on 2022/10/12.
//

#import "MLGetbuyVipApi.h"
@interface  MLGetbuyVipApi()

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *idCard;
@property (nonatomic,copy)NSNumber *payWay;
@property (nonatomic,copy)NSString *vipId;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLGetbuyVipApi

- (id)initWithtoken:(NSString *)token
             payWay:(NSNumber *)payWay
              vipId:(NSString *)vipId
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.payWay = payWay;
        self.vipId = vipId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/vip/buyVip";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,
        @"payWay":self.payWay,
        @"vipId":self.vipId
    };
}

@end
