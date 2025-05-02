//
//  MLFapublishDynamicApi.h
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLFapublishDynamicApi : MLNetwork


- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra

               type:(NSString *)type
            dynamic:(NSString *)dynamic
           chargeId:(NSString *)chargeId
              title:(NSString *)title
           location:(NSString *)location
latitudeAndLongitude:(NSString *)latitudeAndLongitude;


@end

NS_ASSUME_NONNULL_END
