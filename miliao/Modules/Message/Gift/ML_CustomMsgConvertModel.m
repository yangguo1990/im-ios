//
//  ML_CustomMsgConvertModel.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/27.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "ML_CustomMsgConvertModel.h"
#import "ML_GiftAttachment.h"
#import "LDSGiftCellModel.h"
#import "ML_CustomTipsAttachment.h"

@implementation ML_CustomMsgConvertModel

+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene withCount:(NSInteger) count withAnimateType:(NSString *) animateType mutiCount:(NSInteger)mutiCount
{
    if(count <=0){
        count = 1;
    }
    ML_GiftAttachment * attachment = [ML_GiftAttachment new];
    attachment.fromUserId = [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId;
    attachment.toUsersArray = @[userId?:@""];
//    attachment.forwardId = userId?:@"";
    attachment.number = [NSString stringWithFormat:@"%ld",count];
    
    attachment.giftId = giftModel.ID;
    attachment.giftName = giftModel.name;
    attachment.giftSrc = giftModel.icon;
    attachment.giftMoney = giftModel.coin;
    attachment.giftAnimateType = animateType;
    attachment.mutliAmount = [NSString stringWithFormat:@"%@",@(mutiCount)];
    attachment.animationSrc = giftModel.icon_gif;
    UserInfoData * userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    attachment.senderGender = userData.gender;
    attachment.senderWealth = userData.level;
    attachment.senderNickName = userData.name;
    attachment.avatar = userData.icon;
    
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    if(scene != LVChatSceneNone){
        NSDictionary * extDic = @{@"cmd":@"gift",@"scene":@(scene).stringValue};
        message.remoteExt = extDic;
    }
    
    
    message.apnsPayload = @{
        @"apns-collapse-id": message.messageId,
        @"userId" : [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId,
        @"apsField" : @{
            @"mutable-content": @(1),
            @"sound" : @"abc.wav",
            @"alert" : @{
                @"title" :  [ML_AppUserInfoManager sharedManager].currentLoginUserData.name,
                @"body" : [NSString stringWithFormat:@"送给你%@x%ld", giftModel.name, count],
            },
            @"msgType" : @(NIMMessageTypeCustom)
        }
    };
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = YES;
    setting.shouldBeCounted    = YES;
    message.setting            = setting;
    
    return message;
}

+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withCount:(NSInteger) count
{
    return [self msgWithGiftModel:giftModel toUserId:userId withScene:LVChatSceneNone withCount:count];
}
+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId
{
   return [self msgWithGiftModel:giftModel toUserId:userId withScene:LVChatSceneNone];
}

+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene
{
    return [self msgWithGiftModel:giftModel toUserId:userId withScene:scene withCount:1];
}

+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene withCount:(NSInteger) count
{
    extern NSString * LVDefaultAnimateType;
    return [self msgWithGiftModel:giftModel toUserId:userId withScene:scene withCount:count withAnimateType:@"" mutiCount:0];
}

+ (NIMMessage *) msgWithTipContent:(NSString *) content
{
    NSDictionary * attachDic = @{
                                 @"type":@"100",
                                 @"info":@{
                                         @"cmd": @"TIPS_TEXT",
                                         @"icon": @{@"url":@"", @"w":@"1", @"h":@"1"},
                                         @"msg": content?:@"", // 文本消息支持tag标签
                                         }
                                 };
    
    ML_CustomTipsAttachment * tipAttach = [ML_CustomTipsAttachment initWithDic:attachDic];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = tipAttach;
    message.messageObject             = customObject;
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    message.setting            = setting;
    
    return message;
}
@end
