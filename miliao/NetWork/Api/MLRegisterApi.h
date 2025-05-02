//
//  MLRegisterApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLRegisterApi : MLNetwork

- (id)initWithicon:(NSString *)icon
              name:(NSString *)name
           thirdId:(NSDictionary *)thirdId
            gender:(NSString *)gender
             birth:(NSString *)birth
        inviteCode:(NSString *)inviteCode
       channelCode:(NSString *)channelCode
               dev:(NSString *)dev
                nonce:(NSNumber *)nonce
             currTime:(NSString *)currTime
             checkSum:(NSString *)checkSum
              pass:(NSString*)pass
             extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
