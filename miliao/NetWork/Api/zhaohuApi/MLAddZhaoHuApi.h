//
//  MLAddZhaoHuApi.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLAddZhaoHuApi : MLNetwork

- (id)initWithcontent:(NSString *)content
              token:(NSString *)token
              extra:(NSString *)extra;


@end

NS_ASSUME_NONNULL_END
