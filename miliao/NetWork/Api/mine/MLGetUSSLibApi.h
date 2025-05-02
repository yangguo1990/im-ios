//
//  MLGetUSSLibApi.h
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetUSSLibApi : MLNetwork

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
