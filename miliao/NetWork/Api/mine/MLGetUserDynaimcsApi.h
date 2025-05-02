//
//  MLGetUserDynaimcsApi.h
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetUserDynaimcsApi : MLNetwork

- (id)initWithtotoken:(NSString *)token
                  page:(NSString *)page
                 limit:(NSString *)limit
            extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
