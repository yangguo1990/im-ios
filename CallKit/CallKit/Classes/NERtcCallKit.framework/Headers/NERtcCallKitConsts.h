// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef NERtcCallKitConsts_h
#define NERtcCallKitConsts_h

@class NERtcCallKitPushConfig;
@class NERtcCallKitContext;

typedef NS_OPTIONS(NSUInteger, NERtcCallType) {
  NERtcCallTypeAudio = 1,  ///音频
  NERtcCallTypeVideo = 2,  ///视频
};

typedef NS_ENUM(NSUInteger, NERtcSwitchState) {
  NERtcSwitchStateInvite = 1,  /// 邀请
  NERtcSwitchStateAgree = 2,   /// 接受
  NERtcSwitchStateReject = 3,  /// 拒绝
};

typedef NS_ENUM(NSUInteger, NERtcCallStatus) {
  NERtcCallStatusIdle = 0,          /// 闲置
  NERtcCallStatusCalling = 1 << 0,  /// 呼叫中
  NERtcCallStatusCalled = 1 << 1,   /// 正在被呼叫
  NERtcCallStatusInCall = 1 << 2,   /// 通话中
};

typedef NS_ENUM(NSInteger, NERtcCallTerminalCode) {
  TerminalCodeNormal = 0,        ///正常流程
  TerminalCodeTokenError,        /// token 请求失败
  TerminalCodeTimeOut,           ///超时
  TerminalCodeBusy,              ///用户占线
  TerminalCodeRtcInitError,      /// rtc 初始化失败
  TerminalCodeJoinRtcError,      ///加入rtc失败
  TerminalCodeCancelErrorParam,  /// cancel 取消参数错误
  TerminalCodeCallFailed,        ///发起呼叫失败
};

typedef void (^NERtcCallKitTokenHandler)(uint64_t uid, NSString *channelName,
                                         void (^complete)(NSString *token, NSError *error));

typedef void (^NERtcCallKitPushConfigHandler)(NERtcCallKitPushConfig *config,
                                              NERtcCallKitContext *context);

#define kNERtcCallKitBusyCode @"601"

static const NSUInteger kNERtcCallKitMaxTimeOut = 2 * 60;

#define NERtcCallKitDeprecate(msg) __attribute__((deprecated(msg)))

#endif /* NERtcCallKitConsts_h */
