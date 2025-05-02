//
//  MLLogoutApi.h
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_CommunityApi : MLNetwork

- (id)initWithType:(NSString *)type
            ID:(NSString *)ID
              page:(NSString *)page
             limit:(NSString *)limit
          location:(NSString *)location;


@end

NS_ASSUME_NONNULL_END
