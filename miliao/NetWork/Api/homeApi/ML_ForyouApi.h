//
//  ML_ForyouApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_ForyouApi : MLNetwork

- (id)initWithtoken:(NSString *)token
               page:(NSString *)page
              limit:(NSString *)limit
              extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
