//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
//        if ([ML_KBaseUrl isEqualToString:@"http://api.kangs2023.com"]) {
//            _appKey =  @"93e7544c32d0a5577b1a016bbec03755"; // 正式
        _appKey=@"d500692a671acfb5c285032923bb69dc";
//        } else {
//            _appKey = @"f31308a092ca2a9afaa474af066c1935"; // 测试
//        }
        _apiURL = @"https://app.netease.im/api";
#ifdef DEBUG
        _apnsCername = @"miliao_dev_push";
#else
        _apnsCername = @"siliaoPush";
#endif
        _pkCername = @"miliaoPushService";
        
        _redPacketConfig = [[NTESRedPacketConfig alloc] init];        
    }
    return self;
}

- (NSString *)apiURL
{
//    NSAssert([[NIMSDK sharedSDK] isUsingDemoAppKey], @"只有 demo appKey 才能够使用这个API接口".ntes_localized);
    return _apiURL;
}

- (void)registerConfig:(NSDictionary *)config
{
    if (config[@"red_packet_online"])
    {
        _redPacketConfig.useOnlineEnv = [config[@"red_packet_online"] boolValue];
    }
}


@end



@implementation NTESRedPacketConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _useOnlineEnv = YES;
        _aliPaySchemeUrl = @"alipay052969";
        _weChatSchemeUrl = @"wx2a5538052969956e";
    }
    return self;
}

@end
