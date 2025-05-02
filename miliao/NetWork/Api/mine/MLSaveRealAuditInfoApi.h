//
//  MLSaveRealAuditInfoApi.h
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLSaveRealAuditInfoApi : MLNetwork

- (id)initWithtoken:(NSString *)token
            extra:(NSString *)extra
             userId:(NSString *)userId
               name:(NSString *)name
             idCard:(NSString *)idCard;

@end

NS_ASSUME_NONNULL_END
