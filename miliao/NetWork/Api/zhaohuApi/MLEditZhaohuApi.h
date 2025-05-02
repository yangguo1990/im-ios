//
//  MLEditZhaohuApi.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLEditZhaohuApi : MLNetwork

- (id)initWithcontent:(NSString *)content
            contentId:(NSString *)contentId
              token:(NSString *)token
              extra:(NSString *)extra;

@end

NS_ASSUME_NONNULL_END
