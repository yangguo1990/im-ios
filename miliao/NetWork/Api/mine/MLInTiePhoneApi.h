//
//  MLInTiePhoneApi.h
//  miliao
//
//  Created by apple on 2022/11/3.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLInTiePhoneApi : MLNetwork

- (id)initWithcode:(NSString *)code
             extra:(NSString *)extra
             token:(NSString *)token
              phone:(NSString *)phone;


@end

NS_ASSUME_NONNULL_END
