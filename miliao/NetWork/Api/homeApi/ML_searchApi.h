//
//  ML_searchApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_searchApi : MLNetwork

- (id)initWithkeyword:(NSString *)keyword type:(NSString *)type
                 page:(NSString *)page
                limit:(NSString *)limit
                extra:(NSString *)extra
                token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
