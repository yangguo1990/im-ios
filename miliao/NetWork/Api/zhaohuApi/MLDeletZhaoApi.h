//
//  MLDeletZhaoApi.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLDeletZhaoApi : MLNetwork

- (id)initWithids:(NSString *)ids
              token:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
