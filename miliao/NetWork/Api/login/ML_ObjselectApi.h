//
//  ML_ObjselectApi.h
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_ObjselectApi : MLNetwork
- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
             gender:(NSString *)gender;

@end

NS_ASSUME_NONNULL_END
