//
//  ML_FriendModelApi.h
//  miliao
//
//  Created by apple on 2022/9/1.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_FriendModelApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
