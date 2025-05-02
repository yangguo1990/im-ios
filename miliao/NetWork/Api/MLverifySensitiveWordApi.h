//
//  MLverifySensitiveWordApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLverifySensitiveWordApi : MLNetwork

- (id)initWithlist:(NSString *)list
                dev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum;


@end

NS_ASSUME_NONNULL_END
