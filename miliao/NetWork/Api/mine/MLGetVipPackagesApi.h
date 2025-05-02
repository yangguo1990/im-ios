//
//  MLGetVipPackagesApi.h
//  miliao
//
//  Created by apple on 2022/10/11.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGetVipPackagesApi : MLNetwork

- (id)initWithtoken:(NSString *)token
               type:(NSString *)type
              extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
