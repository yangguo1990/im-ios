//
//  MLLogoutApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLLogoutApi : MLNetwork

- (id)initWithdev:(NSString *)dev
            token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
            extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
