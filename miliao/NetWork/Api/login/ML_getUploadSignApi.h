//
//  ML_getUploadSignApi.h
//  miliao
//
//  Created by apple on 2022/8/29.
//

#import "MLNetwork.h"

@interface ML_getUploadSignApi : MLNetwork

- (id)initWithdev:(NSString *)dev
              token:(NSString *)token
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
              extra:(NSString *)extra;

@end
