//
//  MLOnlineMatchingHostListApi.h
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLOnlineMatchingHostListApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
              limit:(NSString *)limit;

@end

NS_ASSUME_NONNULL_END
