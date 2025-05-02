//
//  MGetInviteAwardApi.h
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGetInviteAwardApi : MLNetwork
- (id)initWithtotoken:(NSString *)token
                  page:(NSString *)page
                 limit:(NSString *)limit
            extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
