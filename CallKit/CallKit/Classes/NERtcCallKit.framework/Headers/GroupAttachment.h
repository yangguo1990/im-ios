// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupAttachment : NSObject <NIMCustomAttachment>

/// 自定义消息json转换的哈希结构
@property(nonatomic, strong) NSDictionary *dataDic;

/// 从SDK获取的原始自定义消息字符串
@property(nonatomic, strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
