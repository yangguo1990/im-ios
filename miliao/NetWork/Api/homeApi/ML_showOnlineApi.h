//
//  ML_showOnlineApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_showOnlineApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
