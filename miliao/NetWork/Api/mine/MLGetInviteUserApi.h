//
//  MLGetInviteUserApi.h
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetInviteUserApi : MLNetwork


- (id)initWithtotoken:(NSString *)token
                  page:(NSString *)page
                 limit:(NSString *)limit type:(NSString *)type key:(NSString *)key
            extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
