//
//  ML_getUploadToken.m
//  miliao
//
//  Created by apple on 2022/8/29.
//

#import "ML_getUploadToken.h"

@interface ML_getUploadToken()

@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString *op;
@property (nonatomic,copy)NSString *dev;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;


@end
@implementation ML_getUploadToken

- (id)initWithfileName:(NSString *)fileName
                dev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
              extra:(NSString *)extra{

    if (self = [super init]) {
        self.fileName = fileName;
        self.dev = dev;
        self.token = token;
        self.nonce = nonce;
        self.currTime = currTime;
        self.checkSum = checkSum;
        self.extra = extra;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/base/getUploadToken";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"dev":self.dev,
        @"fileName":self.fileName,
        @"token":self.token,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra
     };
}


@end
