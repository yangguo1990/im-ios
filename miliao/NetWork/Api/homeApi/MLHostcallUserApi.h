//
//  MLHostcallUserApi.h
//  miliao
//
//  Created by apple on 2022/10/19.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLHostcallUserApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
     operationLogId:(NSString *)operationLogId
          contentId:(NSString *)contentId
          toUserId:(NSString *)toUserId;


@end

NS_ASSUME_NONNULL_END
