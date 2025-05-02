//
//  MLZhidingZhaohuApi.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLZhidingZhaohuApi : MLNetwork

- (id)initWithcontentId:(NSString *)contentId
              token:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
