//
//  MLGetNewAuditInfoApi.h
//  miliao
//
//  Created by apple on 2022/11/10.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetNewAuditInfoApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
