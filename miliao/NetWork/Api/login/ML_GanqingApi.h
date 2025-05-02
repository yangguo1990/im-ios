//
//  ML_GanqingApi.h
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_GanqingApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
