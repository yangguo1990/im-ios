//
//  LVCMDAttachment.h
//  LiveVideo
//
//  Created by 林必义 on 2017/5/20.
//  Copyright © 2017年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTESCustomAttachmentDefines.h"

#define LVGiftCMD @"gift"
#define LVGiftFrom @"from"
#define LVGiftTo @"to"
#define LVForward @"forward"
#define LVNumber @"number"
#define LVGiftProperties @"gift"
#define LVGiftId @"id"
#define LVGiftName @"name"
#define LVGiftSrc @"src"
#define LVGiftMoney @"price"
#define LVGiftAnimateType @"anim_type"
#define LVGiftMutiAccount @"multi_amount"
#define LVAnimationSrc @"animationSrc"
#define LVFromUserInfo @"from_userinfo"
#define LVUserID       @"userid"
#define LVNickName     @"nickname"
#define LVGender       @"gender"
#define LVWealth       @"wealth"
#define LVAvatar       @"avatar"


@interface ML_GiftAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
@property(nonatomic,strong) NSDictionary * info;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,copy) NSString * fromUserId;
@property(nonatomic,copy) NSArray * toUsersArray;
//@property(nonatomic,copy) NSString * forwardId;
@property(nonatomic,copy) NSString * number;
@property(nonatomic,copy) NSString * giftId;
@property(nonatomic,copy) NSString * giftName;
@property(nonatomic,copy) NSString * giftSrc;
@property(nonatomic,copy) NSString * giftMoney;
@property(nonatomic,copy) NSString * giftAnimateType;
@property(nonatomic,copy) NSString * mutliAmount;
@property(nonatomic,copy) NSString * avatar;
@property(nonatomic,copy) NSString * animationSrc;
//辅助显示信息
@property(nonatomic,copy) NSString * senderNickName;
@property(nonatomic,copy) NSString * senderGender;
@property(nonatomic,copy) NSString * senderWealth;

+(instancetype) initWithDic:(NSDictionary *) dic;
@end
