//
//  MLGetUserAccessLogsApi.h
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetUserAccessLogsApi : MLNetwork

- (id)initWithtoken:(NSString *)token
                  type:(NSString *)type
                  page:(NSString *)page
                 limit:(NSString *)limit
            extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
