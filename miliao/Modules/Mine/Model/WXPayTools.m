#import "WXPayTools.h"

@interface WXPayTools ()<WXApiDelegate>
@property (nonatomic, copy) void (^authSuccessBlock)(NSString *reqCode);
@property (nonatomic, copy) void (^paySuccessBlock)(void);
@property (nonatomic, copy) void (^payFailedBlock)(void);
@end

@implementation WXPayTools
+ (WXPayTools *)sharedInstance {
    static WXPayTools *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [WXPayTools new];
    });
    return instance;
}

// 回调
- (BOOL)handleOpenURL:(NSURL *)url {
    if ([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay/", WeChat_AppKey]].location == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}
// 回调 Universal Link(通用链接)
- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

/** wechat支付 */
- (void)doWXPay:(NSDictionary *)dataDict paySuccess:(void (^)(void))paySuccessBlock payFailed:(void (^)(void))payFailedBlock; {
    self.paySuccessBlock = paySuccessBlock;
    self.payFailedBlock = payFailedBlock;

    if ([dataDict isKindOfClass:[NSDictionary class]]) {
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = dataDict[@"partnerId"];
        request.prepayId = dataDict[@"prepayId"];
        request.package  = @"Sign=WXPay";
        request.nonceStr = dataDict[@"nonceStr"];
        request.timeStamp = [dataDict[@"timeStamp"] intValue];
        request.sign = dataDict[@"sign"];
        NSLog(@"%@", dataDict);
        [WXApi sendReq:request completion:^(BOOL success) {
            NSLog(@"success - %d", success);
        }];
    }
}

#pragma mark - Delegate回调方法
- (void)onResp:(id)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch(response.errCode) {
            case WXSuccess: {
                NSLog(@"支付成功");
                if (self.paySuccessBlock) {
                    self.paySuccessBlock();
                }
            }  break;

            default: {
                NSLog(@"支付失败");
                if (self.payFailedBlock) {
                    self.payFailedBlock();
                }
            } break;
        }
    }
}
@end
