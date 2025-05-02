//
//  ML_CancelBlackApi.h
//  miliao
//
//  Created by apple on 2022/9/7.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_CancelBlackApi : MLNetwork

- (id)initWithblock:(NSString *)block
             extra:(NSString *)extra
             token:(NSString *)token
          toUserId:(NSString *)toUserId;

@end

NS_ASSUME_NONNULL_END
