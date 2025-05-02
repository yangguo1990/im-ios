//
//  MLNetworkConfig.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLNetworkConfig.h"
#import <YTKNetwork/YTKNetwork.h>
#import "MLNetworkArgumentsFilter.h"

@implementation MLNetworkConfig

+ (void)networkConfig {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = ML_KBaseUrl;
//    config.sessionConfiguration.timeoutIntervalForResource = 1000;
    config.sessionConfiguration.timeoutIntervalForResource = 5;
    [config addUrlFilter:[MLNetworkArgumentsFilter filterUrlWithArguments:@{}]];
    [config setDebugLogEnabled:NO];
    // 由于YTK 没有暴露AF的contentType, 目前只能通过KVO来配置
    //NSSet *contentTypeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/css", @"image/gif", @"multipart/form-data", nil];
    NSSet *contentTypeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/css", @"image/gif", @"multipart/form-data", nil];
    [[YTKNetworkAgent sharedAgent] setValue:contentTypeSet forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
}


@end
