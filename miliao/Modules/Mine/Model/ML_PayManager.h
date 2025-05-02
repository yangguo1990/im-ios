

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_PayManager : NSObject
@property(nonatomic,copy) void(^refreshBlock)(NSString *orderidStr);
+ (ML_PayManager *)sharedPayManager;
+ (void)zhiChongGo;
//- (instancetype)initWithProduct:(NSDictionary *)product;
- (void)goChongWithProduct:(NSDictionary *)product;
@end

NS_ASSUME_NONNULL_END
