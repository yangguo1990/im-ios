#import <Foundation/Foundation.h>
#import "WXApi.h"

#define  WXTools [WXPayTools sharedInstance]

#define  WeChat_AppKey @""

@interface WXPayTools : NSObject
+ (WXPayTools *)sharedInstance;

// 回调
- (BOOL)handleOpenURL:(NSURL *)url;
// 回调 Universal Link(通用链接)
- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

/** wechat支付 */
- (void)doWXPay:(NSDictionary *)reqDict paySuccess:(void (^)(void))paySuccessBlock payFailed:(void (^)(void))payFailedBlock;

@end
