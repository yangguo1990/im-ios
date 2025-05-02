//
//  MLCodeApi.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLNetwork.h"

@interface MLCodeApi : MLNetwork

- (id)initWithphone:(NSString *)phone
                 op:(NSString *)op
                dev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
              extra:(NSString *)extra;

@end
