//
//  MLGetInviteUrlApi.h
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetInviteUrlApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
