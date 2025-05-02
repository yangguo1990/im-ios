// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupCallParam : NSObject

/// 多人通话唯一识别id
@property(nonatomic, strong) NSString *callId;

/// 被邀请的群成员列表
@property(nonatomic, strong) NSArray<NSString *> *calleeList;

@property(nonatomic, strong) NSString *groupId;

/**
  群类型{@link GroupHeader => GroupType }
 */
@property(nonatomic, assign) NSInteger groupType;

/**
  邀请模式{@link GroupHeader => GroupInviteMode }
 */
@property(nonatomic, assign) NSInteger inviteMode;

/**
  加入模式{@link GroupHeader => GroupJoinMode }
 */
@property(nonatomic, assign) NSInteger joinMode;

@property(nonatomic, strong) NSString *extraInfo;

@end

@interface GroupHangupParam : NSObject

@property(nonatomic, strong) NSString *callId;

@property(nonatomic, assign) NSInteger reason;

@end

@interface GroupAcceptParam : NSObject

@property(nonatomic, strong) NSString *callId;

@end

@interface GroupInviteParam : NSObject

@property(nonatomic, strong) NSString *callId;

@property(nonatomic, strong) NSArray<NSString *> *calleeList;

@end

@interface GroupJoinParam : NSObject

@property(nonatomic, strong) NSString *callId;

@end

@interface GroupQueryCallInfoParam : NSObject

@property(nonatomic, strong) NSString *callId;

@end

@interface GroupQueryMembersParam : NSObject

@property(nonatomic, strong) NSString *callId;

@end

@interface GroupConfigParam : NSObject

@property(nonatomic, strong) NSString *host;

/// 是否开启安全模式，默认NO 不开启
@property(nonatomic, assign) BOOL rtcSafeMode;

/// 是否关闭注册自定义消息解码器，默认不开启使用内部自定义消息解码器，外
/// 部使用自定义消息参考接入文档处理自定义消息解码器共同使用问题
@property(nonatomic, assign) BOOL disableDecoder;

/// 是否关闭内部消息过滤，默认关闭内部过滤，如需使用请开启，如果外部也使用过滤功能请透传给SDK
@property(nonatomic, assign) BOOL disableFilter;

/// appkey 或  appid
@property(nonatomic, strong) NSString *appid;

@end

NS_ASSUME_NONNULL_END
