//
//  ML_getBeautyConfigApi.h
//  miliao
//
//  Created by apple on 2022/9/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_getBeautyConfigApi : MLNetwork

- (id)initWithextra:(NSString *)extra
             token:(NSString *)token
             type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
