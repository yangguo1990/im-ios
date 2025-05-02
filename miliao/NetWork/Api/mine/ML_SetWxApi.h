//
//  ML_SetDNDApi.h
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_SetWxApi : MLNetwork

- (id)initWithdnd:(NSString *)dnd
             extra:(NSString *)extra
             token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
