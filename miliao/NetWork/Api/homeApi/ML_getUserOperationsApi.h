//
//  ML_getUserOperationsApi.h
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_getUserOperationsApi : MLNetwork

- (id)initWithtoken:(NSString *)token
                 page:(NSString *)page
                limit:(NSString *)limit
                extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
