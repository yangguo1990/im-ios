//
//  MLlogoffApi.h
//  miliao
//
//  Created by apple on 2022/10/24.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLlogoffApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
