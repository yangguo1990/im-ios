//
//  ML_GetUserInfoApi.h
//  miliao
//
//  Created by apple on 2022/9/7.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_GetUserInfoApi : MLNetwork

- (id)initWithtoken:(NSString *)token
             extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
