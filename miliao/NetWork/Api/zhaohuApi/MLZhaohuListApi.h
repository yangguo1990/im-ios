//
//  MLZhaohuListApi.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLZhaohuListApi : MLNetwork

- (id)initWithstatus:(NSString *)status
               limit:(NSString *)limit
                page:(NSString *)page
              token:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
