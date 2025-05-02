//
//  MLGetAuditInfoApi.h
//  miliao
//
//  Created by apple on 2022/9/19.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetAuditInfoApi : MLNetwork


- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
