//
//  MLLoginApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLLoginApi : MLNetwork

- (id)initWithtype:(NSString *)type
           thirdId:(NSString *)thirdId
       accessToken:(NSString *)accessToken
              code:(NSString *)code
               dev:(NSString *)dev
           yiToken:(NSString *)yiToken
              nonce:(NSNumber *)nonce
           currTime:(NSString *)currTime
           checkSum:(NSString *)checkSum
             extra:(NSString *)extra;
@property (nonatomic,copy)NSString *facebookUserId;

@end

NS_ASSUME_NONNULL_END
