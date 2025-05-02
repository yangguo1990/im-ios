//
//  MLUserHomeApi.h
//  miliao
//
//  Created by apple on 2022/9/22.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLUserHomeApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
           toUserId:(NSString *)toUserId;

@end

NS_ASSUME_NONNULL_END
