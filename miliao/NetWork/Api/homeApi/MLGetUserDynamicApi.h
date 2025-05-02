//
//  MLGetUserDynamicApi.h
//  miliao
//
//  Created by apple on 2022/9/22.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetUserDynamicApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              page:(NSNumber *)page
           toUserId:(NSString *)toUserId;

@end

NS_ASSUME_NONNULL_END
