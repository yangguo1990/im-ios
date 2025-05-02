//
//  MLDelDynamicApi.h
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLDelDynamicApi : MLNetwork

- (id)initWithtotoken:(NSString *)token
            dynamicId:(NSString *)dynamicId
            extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
