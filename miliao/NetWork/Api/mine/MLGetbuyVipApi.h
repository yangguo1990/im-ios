//
//  MLGetbuyVipApi.h
//  miliao
//
//  Created by apple on 2022/10/12.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetbuyVipApi : MLNetwork


- (id)initWithtoken:(NSString *)token
             payWay:(NSNumber *)payWay
              vipId:(NSString *)vipId
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
