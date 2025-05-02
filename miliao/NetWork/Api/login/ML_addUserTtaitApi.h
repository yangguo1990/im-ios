//
//  ML_addUserTtaitApi.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_addUserTtaitApi : MLNetwork

- (id)initWithtoken:(NSString *)token
              extra:(NSString *)extra
             userId:(NSString *)userId
       datingModeId:(NSString *)datingModeId
   emotioRelationId:(NSString *)emotioRelationId
        targetAgeId:(NSString *)targetAgeId
           labelIds:(NSString *)labelIds;


@end

NS_ASSUME_NONNULL_END
