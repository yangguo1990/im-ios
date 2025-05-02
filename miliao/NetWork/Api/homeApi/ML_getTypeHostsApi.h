//
//  ML_getTypeHostsApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_getTypeHostsApi : MLNetwork

- (id)initWithtoken:(NSString *)token
               type:(NSString *)type
               page:(NSString *)page
              limit:(NSString *)limit
           location:(NSString *)location
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
