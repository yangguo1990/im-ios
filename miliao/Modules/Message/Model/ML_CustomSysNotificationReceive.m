//
//  ML_CustomSysNotificationReceive.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/27.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "ML_CustomSysNotificationReceive.h"
#import "NTESCustomAttachmentDefines.h"
#import "UIViewController+CurrentShowVC.h"
#import "ML_GiftAttachment.h"
#import "LVRedDotTitlteManager.h"
#import "LVRollingScreenModel.h"

 NSString * LVVideoVerifyChangeNotification = @"LVVideoVerifyChangeNotification";
NSString * LVForceReloadRedDotAndTitleNotificatioin  = @"LVForceReloadRedDotAndTitleNotificatioin";
NSString * LVPiaoScreenGiftNotification = @"LVPiaoScreenGiftNotification";

@implementation ML_CustomSysNotificationReceive

+(void) dealWithCustomSysNotification:(NSDictionary *) dic
{
    
    extern NSString * LVVideoTextCMD;
    NSDictionary * infoDic = dic[LVInfo];
    if([infoDic isKindOfClass:[NSDictionary class]]){
        NSString * cmd = infoDic[LVCMD];
        if([cmd isEqualToString:@"payment"]){
            NSString * goldNumber = infoDic[@"goldcoin"];
            NSString * rechargeNumber = infoDic[@"recharge"];
            UserInfoData * data = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
            data.activeCoin = goldNumber;
            [ML_AppUserInfoManager sharedManager].currentLoginUserData = data;
            extern NSString * LVRefreshGoldNumberNotificaton;
            [[NSNotificationCenter defaultCenter] postNotificationName:LVRefreshGoldNumberNotificaton object:nil];
            
            extern NSString * LVChargeNotification;
            [[NSNotificationCenter defaultCenter] postNotificationName:LVChargeNotification object:nil];

            
            
        }else if([cmd isEqualToString:@"video_verify"]){
            NSString * status = infoDic[@"status"];
            UserInfoData * data = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//            data.videoVerified = status;
//            data.videoVeryTip = @"0";
            [ML_AppUserInfoManager sharedManager].currentLoginUserData = data;
            [[NSNotificationCenter defaultCenter] postNotificationName:LVVideoVerifyChangeNotification object:nil];
        }else if([cmd isEqualToString:@"live_notice"]){
            NSString * msgText = infoDic[@"msg"];
            NSString * color = infoDic[@"color"];
            extern NSString * LVLiveNoticeNotification ;
            NSDictionary * msgDic = @{@"msg":msgText?:@"",@"color":color?:@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:LVLiveNoticeNotification object:msgDic.copy];
            
        }else if([cmd isEqualToString:@"live_join"]){
            NSDictionary * userInfoDic = infoDic[@"userinfo"];
            NSString * msg = infoDic[@"msg"];
            if([userInfoDic isKindOfClass:[NSDictionary class]]){
                NSString * userId  = userInfoDic[@"userid"];
                NSString * nickName = userInfoDic[@"nickname"];
                NSString * wealth = userInfoDic[@"wealth"];
                NSString * vipType = userInfoDic[@"vip"];
                if(!msg.length){
                    msg = @"路过房间";
                }
                NSDictionary * msgDic = @{@"userid":userId?:@"",@"nickname":nickName?:@"",@"wealth":wealth?:@"",@"msg":msg,@"vip":vipType?:@"0"};
                extern NSString * LVLiveEnterNotification;
                [[NSNotificationCenter defaultCenter] postNotificationName:LVLiveEnterNotification object:msgDic];
            }
          
        }else if([cmd isEqualToString:LVGiftCMD]){
            NSString * fromUserId = infoDic[@"from"];
            NSString * number  =infoDic[@"number"];
            NSDictionary * giftDic = infoDic[@"gift"];
            NSDictionary * userinfoDic = infoDic[LVFromUserInfo];
            if([giftDic isKindOfClass:[NSDictionary class]] && [userinfoDic isKindOfClass:[NSDictionary class]]){
                NSString * name = giftDic[@"name"];
                NSString * giftUrl = giftDic[LVGiftSrc]?:@"";
                NSString * msg = [NSString stringWithFormat:@"送出%@个[%@]",number,name];
                NSString * wealth = userinfoDic[LVWealth];
                NSString * nickName = userinfoDic[LVNickName];
                NSString * vipType = userinfoDic[@"vip"]?:@"0";
                NSDictionary * msgDic = @{@"fromuserid":fromUserId?:@"",@"msg":msg,@"nickname":nickName?:@"",@"wealth":wealth?:@"",@"gifturl":giftUrl,@"vip":vipType};
                
                extern NSString * LVLiveGiftTipNotification;
                [[NSNotificationCenter defaultCenter] postNotificationName:LVLiveGiftTipNotification object:msgDic];
                
                NSString * giftPrice = giftDic[LVGiftMoney]?:@"0";
                NSDictionary * sendGiftDic = @{@"fromuserid":fromUserId?:@"",@"price":giftPrice};
                extern NSString * LVReceiveGiftProfitNotification;
                [[NSNotificationCenter defaultCenter] postNotificationName:LVReceiveGiftProfitNotification object:sendGiftDic];
            }
        }else if([cmd isEqualToString:LVVideoTextCMD]){//通话中文本消息
            NSString * fromUserId = infoDic[@"from"];
            NSDictionary * userinfoDic = infoDic[LVFromUserInfo];
            if([userinfoDic isKindOfClass:[NSDictionary class]]){
                NSString * msg = infoDic[@"msg"];
                NSString * wealth = userinfoDic[LVWealth];
                NSString * nickName = userinfoDic[LVNickName];
                NSString * vipType = userinfoDic[@"vip"]?:@"0";
                NSDictionary * msgDic = @{@"fromuserid":fromUserId?:@"",@"msg":msg,@"nickname":nickName?:@"",@"wealth":wealth?:@"",@"vip":vipType};
                
                extern NSString * LVLiveTextTipNotification;
                [[NSNotificationCenter defaultCenter] postNotificationName:LVLiveTextTipNotification object:msgDic];
                
            
            }
        }else if([cmd isEqualToString:@"payment_vip"]){
            UIViewController * topVC =  [UIViewController topShowViewController];
            
            
        }else if([cmd isEqualToString:@"endcall"]){
            id channelID = infoDic[@"channelid"];
            NSString * msg = infoDic[@"msg"];
            if(channelID){
                NSString * channelIDStr = [NSString stringWithFormat:@"%@",channelID];
                extern NSString * LVForceEndCallNotification;
                [[NSNotificationCenter defaultCenter] postNotificationName:LVForceEndCallNotification object:channelIDStr];
                
            }
            if([msg isKindOfClass:[NSString class]] && [msg length]){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alertView show];
                });
            }
        }else if([cmd isEqualToString:@"switch"]){
           // NSString * ca = infoDic[@"ca"];
            
        }else if([cmd isEqualToString:@"guard"]){
            
        }else if([cmd isEqualToString:@"guardme"]){
             [self updateCallInterfaceGuardViewWithDic:infoDic];
        }else if([cmd isEqualToString:@"chatctrl"]){
            extern NSString * LVResetMsgLimitCountNotification;
            NSDictionary * chatDic = infoDic[@"send_msg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:LVResetMsgLimitCountNotification object:chatDic];
        }else if([cmd isEqualToString:@"updateguardscore"]){
            extern NSString * LVRefreshFriendlyNotification;
            [[NSNotificationCenter defaultCenter] postNotificationName:LVRefreshFriendlyNotification object:infoDic];
        }else if([cmd isEqualToString:@"redpacket_encrypted"] || [cmd isEqualToString:@"redpacket_normal"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
                
            });
        }else if([cmd isEqualToString:@"TOOLTIP_DOT"]){
            NSString * type = infoDic[@"position"];
            [LVRedDotTitlteManager LVUpdateRedDotValue:YES forTypeStr:type];
            [[NSNotificationCenter defaultCenter] postNotificationName:LVForceReloadRedDotAndTitleNotificatioin object:nil];
        }else if([cmd isEqualToString:@"TOOLTIP_TEXT"]){
            NSString * type = infoDic[@"position"];
            NSString * value = infoDic[@"msg"];
            [LVRedDotTitlteManager LVUpdateTitleValue:value forTypeStr:type];
            [[NSNotificationCenter defaultCenter] postNotificationName:LVForceReloadRedDotAndTitleNotificatioin object:nil];
        }else if([cmd isEqualToString:@"TOOLTIP_CLEAN"]){
             NSString * type = infoDic[@"position"];
             [LVRedDotTitlteManager LVUpdateRedDotValue:NO forTypeStr:type];
             [LVRedDotTitlteManager LVUpdateTitleValue:@"" forTypeStr:type];
             [[NSNotificationCenter defaultCenter] postNotificationName:LVForceReloadRedDotAndTitleNotificatioin object:nil];
        }else if([cmd isEqualToString:@"DANMU_GIFT"]){
            NSDictionary * fromUserInfoDic = infoDic[@"from_userinfo"];
            NSDictionary * toUserInfoDic = infoDic[@"to_userinfo"];
            NSDictionary * giftDic = infoDic[@"gift"];
            if([fromUserInfoDic isKindOfClass:[NSDictionary class]] && [toUserInfoDic isKindOfClass:[NSDictionary class]] && [giftDic isKindOfClass:[NSDictionary class]]){
                LVRollingScreenModel * model = [LVRollingScreenModel new];
                model.senderName = fromUserInfoDic[@"nickname"];
                model.receiverName = toUserInfoDic[@"nickname"];
                model.giftName = giftDic[@"name"];
                model.giftCount = infoDic[@"number"];
                model.giftUrl = giftDic[@"src"];
                model.senderIconUrl = fromUserInfoDic[@"avatar"];
                model.bgColor = infoDic[@"bgcolor"];
                model.opacityStr = infoDic[@"opacity"];
                model.extImgTag =infoDic[@"ext_image"];
            
                [[NSNotificationCenter defaultCenter] postNotificationName:LVPiaoScreenGiftNotification object:model];
            }
        }else if([cmd isEqualToString:@"DANMU_GENERAL"]){

            LVRollingScreenNormalModel * model = [LVRollingScreenNormalModel new];
            model.avatarUrl = infoDic[@"avatar"];
            model.title = infoDic[@"title"];
            model.titleColor = infoDic[@"title_color"];
            model.subTitle = infoDic[@"subtitle"];
            model.subTitleColor = infoDic[@"subtitle_color"];
            model.redirectUrl = infoDic[@"url"];
            model.extImgTag = infoDic[@"ext_image"];
            model.bgColor = infoDic[@"bgcolor"];
            model.opacityStr = infoDic[@"opacity"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LVPiaoScreenGiftNotification object:model];
        }

        
    }
}

+(void) updateCallInterfaceGuardViewWithDic:(NSDictionary *) dic
{
    extern NSString * LVOpenGuardVIPSuccessNotification;
    NSDictionary * user = dic[@"user1"];
    NSDictionary * user2 = dic[@"user2"];
    if([user isKindOfClass:[NSDictionary class]] && [user2 isKindOfClass:[NSDictionary class]]){
        NSString * userId1 = user[@"userid"];
        NSString * userId2 = user2[@"userid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:LVOpenGuardVIPSuccessNotification object:@{@"userid1":userId1?:@"",@"userid2":userId2?:@""}];
    }
}


@end
