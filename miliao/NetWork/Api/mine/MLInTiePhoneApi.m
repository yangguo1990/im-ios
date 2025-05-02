//
//  MLInTiePhoneApi.m
//  miliao
//
//  Created by apple on 2022/11/3.
//

#import "MLInTiePhoneApi.h"
@interface MLInTiePhoneApi()

@property (nonatomic,copy)NSString *block;
@property (nonatomic,copy)NSString *toUserId;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLInTiePhoneApi

- (id)initWithcode:(NSString *)code
             extra:(NSString *)extra
             token:(NSString *)token
              phone:(NSString *)phone{

    if (self = [super init]) {
        self.code = code;
        self.extra = extra;
        self.token = token;
        self.phone = phone;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/login/inTiePhone";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"code":self.code,
        @"extra":self.extra,
        @"token":self.token,
        @"phone":self.phone
    };
}

@end
