//
//  MLNameCheckApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

@interface MLNameCheckApi : MLNetwork

- (id)initWithname:(NSString *)name
             dev:(NSString *)dev
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
             extra:(NSString *)extra;
@end
