//
//  MLGetLableLibApi.h
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetLableLibApi : MLNetwork

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra
               host:(NSString *)host;

@end

NS_ASSUME_NONNULL_END
