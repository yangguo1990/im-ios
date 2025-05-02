//
//  MLNetworkResponse.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLNetworkResponse.h"

@implementation MLNetworkResponse

- (id)data
{
    return [NSObject changeType:_data];
}
@end
