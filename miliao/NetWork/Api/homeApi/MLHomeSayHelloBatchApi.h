//
//  MLHomeSayHelloBatchApi.h
//  miliao
//
//  Created by apple on 2022/11/16.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLHomeSayHelloBatchApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
          contentId:(NSString *)contentId
          toUserIds:(NSString *)toUserIds;

@end

NS_ASSUME_NONNULL_END
