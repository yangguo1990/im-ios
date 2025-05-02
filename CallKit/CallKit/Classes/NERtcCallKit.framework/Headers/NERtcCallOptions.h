// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NERtcCallOptions : NSObject

/// 推送证书名称
@property(nonatomic, copy) NSString *APNSCerName;

/// 呼叫推送证书名称
@property(nonatomic, copy) NSString *VoIPCerName;

/// 是否同时初始化Rtc，默认YES。
@property(nonatomic, assign) BOOL shouldInitializeRtc;

/// 被叫是否自动加入channel
@property(nonatomic, assign) BOOL supportAutoJoinWhenCalled;

/// 是否关闭话单，默认NO不关闭
@property(nonatomic, assign) BOOL disableRecord;

@end

NS_ASSUME_NONNULL_END
