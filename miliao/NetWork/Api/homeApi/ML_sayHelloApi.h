//
//  ML_sayHelloApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_sayHelloApi : MLNetwork

- (id)initWithtoken:(NSString *)token
           toUserId:(NSString *)toUserId
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
