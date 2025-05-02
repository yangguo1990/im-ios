//
//  MLFocusApi.h
//  miliao
//
//  Created by apple on 2022/9/23.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLFocusApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
           toUserId:(NSString *)toUserId
               type:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
