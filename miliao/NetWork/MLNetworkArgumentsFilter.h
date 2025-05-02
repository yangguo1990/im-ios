//
//  MLNetworkArgumentsFilter.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKNetwork.h>

@interface MLNetworkArgumentsFilter : NSObject<YTKUrlFilterProtocol>

+ (MLNetworkArgumentsFilter *)filterUrlWithArguments:(NSDictionary *)arguments;

@end
