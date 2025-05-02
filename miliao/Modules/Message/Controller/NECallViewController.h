//
//  NECallViewController.h
//  NERtcCallKit
//
//  Created by I am Groot on 2020/8/21.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import "NEVideoView.h"
#import "JPSuspensionEntrance.h"

@class NECustomButton;
NS_ASSUME_NONNULL_BEGIN

@interface NECallViewController : UIViewController <JPSuspensionEntranceProtocol>
//@property (nonatomic, assign) BOOL isPipei;
@property (nonatomic, strong) MLNetworkResponse *response;
@property (nonatomic, assign) BOOL autoJie;
@property(nonatomic, assign) BOOL isuseFU;
/// 如果正在dismiss，提供dismiss完成的回调
@property (nonatomic, copy) void(^dismissCompletion)(void);

/// 初始化ViewController
/// @param member 对方IM账号
/// @param isCalled 是否是被呼叫
/// @param type 语音或视频
- (instancetype)initWithOtherMember:(NSString *)member isCalled:(BOOL)isCalled type:(NERtcCallType)type;
- (void)acceptEvent:(NECustomButton *)button; // 接听
- (instancetype)initWithOtherMember:(NSString *)member isCalled:(BOOL)isCalled type:(NERtcCallType)type isAutojie:(BOOL)autoJie response:(MLNetworkResponse *)response;
@end

NS_ASSUME_NONNULL_END
