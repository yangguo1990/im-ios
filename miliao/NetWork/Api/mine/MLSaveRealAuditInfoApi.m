//
//  MLSaveRealAuditInfoApi.m
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "MLSaveRealAuditInfoApi.h"
@interface  MLSaveRealAuditInfoApi()

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *idCard;
@property (nonatomic,copy)NSString *limit;
@property (nonatomic,copy)NSString *host;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLSaveRealAuditInfoApi

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra
             userId:(NSString *)userId
               name:(NSString *)name
             idCard:(NSString *)idCard{

    if (self = [super init]) {
        self.token = token;
        self.extra = extra;
        self.userId = userId;
        self.name = name;
        self.idCard = idCard;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/saveRealAuditInfo";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"token":self.token,
        @"extra":self.extra,

        @"userId":self.userId,
        @"name":self.name,
        @"idCard":self.idCard
    };
}

@end
