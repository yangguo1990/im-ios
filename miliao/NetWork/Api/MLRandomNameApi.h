//
//  MLRandomNameApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"


@interface MLRandomNameApi : MLNetwork

- (id)initWithdev:(NSString *)dev
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
            extra:(NSString *)extra;

@end
