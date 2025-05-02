//
//  NTESNotificationCenter.m
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNotificationCenter.h"
#import "MLTabbarViewController.h"
#import "ML_SessionViewController.h"
#import "NSDictionary+NTESJson.h"
#import "NTESCustomNotificationDB.h"
#import "NTESCustomNotificationObject.h"
#import "UIView+Toast.h"
#import "NTESCustomSysNotificationSender.h"
#import "NTESGlobalMacro.h"
#import <AVFoundation/AVFoundation.h>
#import "NTESLiveViewController.h"
#import "NTESSessionMsgConverter.h"
#import "NTESSessionUtil.h"
#import "NTESTeamMeetingCalleeInfo.h"
#import "NTESAVNotifier.h"
#import "NTESRedPacketTipAttachment.h"
#import "NECallViewController.h"
#import "NEGroupCallVC.h"
#import <NERtcCallKit/NERtcCallKit.h>
#import "ML_CustomSysNotificationReceive.h"
#import "ML_GiftAttachment.h"
#import "ML_SessionViewController.h"
#import "NECallViewController.h"
#import "ML_SHowView.h"
#import "LVRollingScreenView.h"
#import "ML_MsgListVC.h"
#import "ML_GetUserInfoApi.h"
#import "MLHomeViewController.h"
#import "MLCommunityViewController.h"
#import "MLMineViewController.h"
#import "LDSGiftShowManager.h"

NSString *NTESCustomNotificationCountChanged = @"NTESCustomNotificationCountChanged";

@interface NTESNotificationCenter () <NIMSystemNotificationManagerDelegate,NIMChatManagerDelegate,NIMBroadcastManagerDelegate, NIMSignalManagerDelegate, NIMConversationManagerDelegate,NERtcCallKitDelegate>

@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音
@property (nonatomic,strong) NTESAVNotifier *notifier;

@property (nonatomic,strong) NSDate *userDate; //更新用户信息时间，一分钟内只跟新一次
@end

@implementation NTESNotificationCenter

+ (instancetype)sharedCenter
{
    static NTESNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"message" withExtension:@"wav"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _notifier = [[NTESAVNotifier alloc] init];
        
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        
        [[NIMSDK sharedSDK].signalManager addDelegate:self];
        [[NIMSDK sharedSDK].conversationManager addDelegate:self];
        
        [[NERtcCallKit sharedInstance] addDelegate:self];
        
    }
    return self;
}


- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].broadcastManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

#pragma mark - NIMConversationDelegate

- (void)didServerSessionUpdated:(NIMRecentSession *)recentSession {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:[NSString stringWithFormat:@"%@",recentSession.serverExt] duration:1 position:CSToastPositionCenter];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)recvMessages
{
    NSArray *messages = recvMessages;
    if (messages.count)
    {
        static BOOL isPlaying = NO;
        if (isPlaying) {
            return;
        }
        isPlaying = YES;
        [self playMessageAudioTip];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isPlaying = NO;
        });
        [self checkMessageAt:messages];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jieMsg" object:messages];
        
        //拦截礼物消息
        [self dealWithPresentMessages:messages];
    }
}


-(void) dealWithPresentMessages:(NSArray *) messages
{
    int i = 0;
    for (NIMMessage *message in messages) {
        if (message.session.sessionType != NIMSessionTypeTeam) {
            static BOOL isPlaying = NO;
            if (isPlaying) {
                //        return;   // BY注释
            }
            isPlaying = YES;
            if (message.text && message.text.length > 0) {
                NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
                NIMUserInfo *userInfo = user.userInfo;
                if(userInfo.nickName.length){
//                    [self playMessageAudioTip:[NSString stringWithFormat:@"%@: %@",userInfo.nickName,message.text]];
                }else{
                    [ML_AppUtil fetchUserInfoNecessaryById:message.from withBlock:^(NSError *error) {
//                        if (userInfo.nickName.length) {
//                            [self playMessageAudioTip:[NSString stringWithFormat:@"%@: %@",userInfo.nickName,message.text]];
//                        }else{
//                            [self playMessageAudioTip:message.text];
//                        }
                    }];
                }
            }else{
//                [self playMessageAudioTip:@"您收到了一条消息"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                isPlaying = NO;
            });
        }
        NIMCustomObject *object = message.messageObject;
        NSString *text = nil;
        if (message.messageType == 100) {
            text = @"[你收到一条礼物消息]";
        } else if (message.messageType == NIMMessageTypeImage) {
            text = @"[你收到一条图片消息]";
        } else if (message.messageType == NIMMessageTypeAudio) {
            text = @"[你收到一条声音消息]";
        } else if (message.messageType == NIMMessageTypeVideo) {
            text = @"[你收到一条视频消息]";
        } else if (message.messageType == NIMMessageTypeNotification) {
            text = @"[你收到一条通知消息]";
        } else if (message.messageType == NIMMessageTypeText) {
            text = message.text?:@"";
        } else {
            return;
        }
        
        NSString * cUserId = [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId;
        
        if ((![[UIViewController topShowViewController] isKindOfClass:[ML_SessionViewController class]] &&
            ![[UIViewController topShowViewController] isKindOfClass:[NECallViewController class]] &&
             ![[UIViewController topShowViewController] isKindOfClass:[ML_MsgListVC class]]) &&
            i == messages.count-1 &&
            ![message.from isEqualToString:[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId] &&
            ![message.from isEqualToString:@"10000000"]) {
            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : message.from?:@""} urlStr:@"host/getUserInfo"];
            kSelf;
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                
                NSMutableDictionary *tagDic = [NSMutableDictionary dictionaryWithDictionary:response.data[@"userInfo"]];
                [tagDic setObject:text forKey:@"text"];
                [tagDic setObject:message.from?:@"" forKey:@"userId"];
//                if ((![[UIViewController topShowViewController] isKindOfClass:[ML_SessionViewController class]] &&
//                     ![[UIViewController topShowViewController] isKindOfClass:[NECallViewController class]] &&
//                     ![[UIViewController topShowViewController] isKindOfClass:[ML_SessionListViewController class]])) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tanReceiveText" object:tagDic];
//                }
            } error:^(MLNetworkResponse *response) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        i++;
        if( message.messageType == NIMMessageTypeCustom && [object.attachment isKindOfClass:[ML_GiftAttachment class]] && ![cUserId isEqualToString:message.from]) {
            
            
            //  mes  对象里个 rawAttachContent  json字符串，把它转化成一个数据model或者一个字典给我使用即可
            NIMMessage *mes = (NIMMessage *)object.message;
            

            ML_GiftAttachment * giftAttach = (ML_GiftAttachment *)object.attachment;
            
            if (/*[[UIViewController topShowViewController] isKindOfClass:[ML_SessionViewController class]] ||*/
                [[UIViewController topShowViewController] isKindOfClass:[MLHomeViewController class]] ||
                [[UIViewController topShowViewController] isKindOfClass:[MLCommunityViewController class]] ||
                [[UIViewController topShowViewController] isKindOfClass:[MLMineViewController class]] ||
                [cUserId isEqualToString:mes.from]) {
                return;
            }
                LDSGiftModel *giftModel = [[LDSGiftModel alloc] init];
                giftModel.giftGifImage = giftAttach.animationSrc;
            giftModel.giftName = giftAttach.giftName;
            giftModel.sendCount = [giftAttach.number integerValue];
            giftModel.giftId = giftAttach.giftId;
            giftModel.userName = [ML_AppUserInfoManager sharedManager].currentLoginUserData.name;
            giftModel.userIcon = giftAttach.avatar;
            giftModel.giftImage = giftAttach.giftSrc;
                [[LDSGiftShowManager shareInstance] showGiftViewWithBackView:[UIViewController topShowViewController].view info:giftModel completeBlock:^(BOOL finished) {
                    //结束
                }];
            
                if ([giftAttach.animationSrc length]) {
                    
                    //播放礼物动画
                    [[LVRollingScreenView sharedRollingScreenView] startShowGiftViewWithBigGiftModel:giftModel];
                } else {
                    NSLog(@"没有大动画=");
                }
              
        }

        
    }
    
}

//- (void)playMessageAudioTip:(NSString *)text
//{
//   // UINavigationController *nav = [NTESMainTabController instance].selectedViewController;
//    UINavigationController * nav = (UINavigationController *) [MLTabbarViewController instance].selectedViewController;
//    BOOL needPlay = YES;
//    for (UIViewController *vc in nav.viewControllers) {
//        if ([vc isKindOfClass:[NIMSessionViewController class]] ||  /*[vc isKindOfClass:[NTESLiveViewController class]] ||*/ [vc isKindOfClass:[NTESNetChatViewController class]] || [vc isKindOfClass:[LVLivingController class]] || [vc isKindOfClass:[LVVoiceLivingController class]])
//        {
//            needPlay = NO;
//            break;
//        }
//        if ([LVLivingRoomManager shareInstance].isLiving == YES) {
//            needPlay = NO;
//        }
//    }
//    if (needPlay) {
//        [self.player stop];
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:nil];
//        [self.player play];
//        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
//        localNoti.alertBody = text;
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNoti];
//    }
//}


- (void)playMessageAudioTip
{
    UINavigationController *nav = [MLTabbarViewController instance].selectedViewController;
    BOOL needPlay = YES;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[NIMSessionViewController class]] ||  [vc isKindOfClass:[NTESLiveViewController class]] || [vc isKindOfClass:[NECallViewController class]]  || [vc isKindOfClass:[NEGroupCallVC class]] )
        {
            needPlay = NO;
            break;
        }
    }
    if (needPlay) {
        [self.player stop];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:nil];
        [self.player play];
    }
}

- (void)checkMessageAt:(NSArray<NIMMessage *> *)messages
{
    //一定是同个 session 的消息
    NIMSession *session = [messages.firstObject session];
    if ([self.currentSessionViewController.session isEqual:session])
    {
        //只有在@所属会话页外面才需要标记有人@你
        return;
    }

    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];

    for (NIMMessage *message in messages) {
        if ([message.apnsMemberOption.userIds containsObject:me]) {
            [NTESSessionUtil addRecentSessionMark:session type:NTESRecentSessionMarkTypeAt];
            return;
        }
    }
}


//- (NSArray *)filterMessages:(NSArray *)messages
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NIMMessage *message in messages)
//    {
//        if ([self checkRedPacketTip:message] && ![self canSaveMessageRedPacketTip:message])
//        {
//            [[NIMSDK  sharedSDK].conversationManager deleteMessage:message];
//            [self.currentSessionViewController uiDeleteMessage:message];
//            continue;
//        }
//        [array addObject:message];
//    }
//    return [NSArray arrayWithArray:array];
//}


//- (BOOL)checkRedPacketTip:(NIMMessage *)message
//{
//    NIMCustomObject *object = message.messageObject;
//    if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[NTESRedPacketTipAttachment class]])
//    {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL)canSaveMessageRedPacketTip:(NIMMessage *)message
//{
//    NIMCustomObject *object = message.messageObject;
//    NTESRedPacketTipAttachment *attach = (NTESRedPacketTipAttachment *)object.attachment;
//    NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
//    return [attach.sendPacketId isEqualToString:me] || [attach.openPacketId isEqualToString:me];
//}

- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification
{
    NIMMessage *tipMessage = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:notification]];
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.shouldBeCounted = NO;
    tipMessage.setting = setting;
    tipMessage.timestamp = notification.timestamp;
    
    MLTabbarViewController *tabVC = [MLTabbarViewController instance];
    UINavigationController *nav = tabVC.selectedViewController;

    for (ML_SessionViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[ML_SessionViewController class]]
            && [vc.session.sessionId isEqualToString:notification.session.sessionId]) {
            NIMMessageModel *model = [vc uiDeleteMessage:notification.message];
            if (notification.notificationType == NIMRevokeMessageNotificationTypeP2POneWay ||
                notification.notificationType == NIMRevokeMessageNotificationTypeTeamOneWay)
            {
                break;
            }
            
            if (model) {
                [vc uiInsertMessages:@[tipMessage]];
            }
            break;
        }
    }
    
    // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
    if (notification.notificationType != NIMRevokeMessageNotificationTypeP2POneWay &&
        notification.notificationType != NIMRevokeMessageNotificationTypeTeamOneWay)
    {
        [[NIMSDK sharedSDK].conversationManager saveMessage:tipMessage
                                                 forSession:notification.session
                                                 completion:nil];
    }
    
}

- (void)onRecvMessageDeleted:(NIMMessage *)message ext:(NSString *)ext
{

    MLTabbarViewController *tabVC = [MLTabbarViewController instance];
    UINavigationController *nav = tabVC.selectedViewController;

    for (ML_SessionViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[ML_SessionViewController class]]
            && [vc.session.sessionId isEqualToString:message.session.sessionId]) {
            [vc uiDeleteMessage:message];
        }
    }
}


#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
//    NSString *content = notification.content;
//
//    if ([dic[@"id"] intValue] == 1008) {

//    }
//
    NSDate *now = [NSDate date];
    if (self.userDate == nil) {
        self.userDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:self.userDate];
    if (timeInterval > 60) {
        self.userDate = now;

        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"push/getPushMessage"];
        kSelf;
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/official"/*@"push/getNewestPushMessage"*/];

            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

                if (response.data != nil) {
                    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                    userData.officialInfo = response.data;
                    [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
                    POST_NOTIFICATION(@"officialNot", nil, nil);
                }
            } error:^(MLNetworkResponse *response) {
                NSLog(@"%@", response);
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];


        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {

        }];
    }
    

    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            
            NSLog(@"dict = %@", dict);
            switch ([dict jsonInteger:NTESNotifyID]) {

                case NTESCustom:{
                    //SDK并不会存储自定义的系统通知，需要上层结合业务逻辑考虑是否做存储。这里给出一个存储的例子。
                    NTESCustomNotificationObject *object = [[NTESCustomNotificationObject alloc] initWithNotification:notification];
                    //这里只负责存储可离线的自定义通知，推荐上层应用也这么处理，需要持久化的通知都走可离线通知
                    if (!notification.sendToOnlineUsersOnly) {
                        [[NTESCustomNotificationDB sharedInstance] saveNotification:object];
                    }
                    if (notification.setting.shouldBeCounted) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
                    }
                    NSString *content  = [dict jsonString:NTESCustomContent];
                    [self makeToast:content];
                    break;
                }
                case 1008:{
                    
                    NSData *data2 = [dict[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:data2
                                                                             options:0
                                                                               error:nil];
                    
                    if (dict2) {
                        [ML_TanchuangView showWithTitle:dict2[@"content"]?:@"违规操作！" time:5];
                    }
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"tichuRoom" object:nil];
//
//                    });
                        
                    break;
                }
                case 1010:{
                    
                    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"wallet/getMyWallet"];
                    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        
                        UserInfoData *jinJi = [UserInfoData mj_objectWithKeyValues:response.data]; // 为了判断返回奇怪现象，用这个来接收币和积分
                        
                        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                        currentData.coin = jinJi.coin;
                        currentData.credit = jinJi.credit;
                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        
                    } error:^(MLNetworkResponse *response) {

                    } failure:^(NSError *error) {
                        
                    }];
                    
                    break;
                }
                case 1011:{
                    
                    
                    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                    currentData.verified = @"1";
                    [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                    
                    break;
                }
                case 1012:{
                    
                    
                    kSelf;
                    ML_GetUserInfoApi *api = [[ML_GetUserInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token?:@"" extra:[self jsonStringForDictionary]];
                    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        NSLog(@"我的信息---%@",response.data);

                        UserInfoData * loginCurrentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

                        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
                        if (response.data[@"pay"]) {
                            currentData.alipay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"alipay"]];
                            currentData.wxpay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"wxpay"]];
                        }
                        currentData.domain = loginCurrentData.domain;
                        currentData.thirdId = loginCurrentData.thirdId;
                        currentData.imToken = loginCurrentData.imToken;
                        currentData.must = loginCurrentData.must;
                        currentData.token = loginCurrentData.token;
                        currentData.userId = loginCurrentData.userId;
                        currentData.wxPay = loginCurrentData.wxPay;

                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        
                    } error:^(MLNetworkResponse *response) {

                    } failure:^(NSError *error) {

                    }];
                    
                    break;
                }
                case 1013:{
                    
                    
                    kSelf;
                    ML_GetUserInfoApi *api = [[ML_GetUserInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token?:@"" extra:[self jsonStringForDictionary]];
                    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        NSLog(@"我的信息---%@",response.data);

                        UserInfoData * loginCurrentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

                        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
                        if (response.data[@"pay"]) {
                            currentData.alipay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"alipay"]];
                            currentData.wxpay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"wxpay"]];
                        }
                        currentData.domain = loginCurrentData.domain;
                        currentData.thirdId = loginCurrentData.thirdId;
                        currentData.imToken = loginCurrentData.imToken;
                        currentData.must = loginCurrentData.must;
                        currentData.token = loginCurrentData.token;
                        currentData.userId = loginCurrentData.userId;
                        currentData.wxPay = loginCurrentData.wxPay;

                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        
                    } error:^(MLNetworkResponse *response) {

                    } failure:^(NSError *error) {

                    }];
                    break;
                }
                case 1015:{
                    
                    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"wallet/getMyWallet"];
                    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        
                        UserInfoData *jinJi = [UserInfoData mj_objectWithKeyValues:response.data]; // 为了判断返回奇怪现象，用这个来接收币和积分
                        
                        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                        currentData.coin = jinJi.coin;
                        currentData.credit = jinJi.credit;
                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        
                    } error:^(MLNetworkResponse *response) {

                    } failure:^(NSError *error) {
                        
                    }];
                    
                    break;
                }
                default:
                    break;
            }
        }
    }
}
#pragma mark - NERtcCallKitDelegate

- (void)onError:(NSError *)error {
    NSLog(@"error:%@",error);
    if (error.code == kNERtcErrInvalidState) {
        [UIApplication.sharedApplication.delegate.window makeToast:@"您的操作太过频繁，请稍后再试"];
    }
}

- (void)onInvited:(NSString *)invitor userIDs:(NSArray<NSString *> *)userIDs isFromGroup:(BOOL)isFromGroup groupID:(nullable NSString *)groupID type:(NERtcCallType)type attachment:(nullable NSString *)attachment
{
    MLTabbarViewController *tabVC = [MLTabbarViewController instance];
    [tabVC.view endEditing:YES];

    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : invitor, @"isNotSend" : @(![ML_AppUtil isCensor])} urlStr:@"im/preCall"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        NSDictionary *dic = response.data;
        
        __block NECallViewController *callVC = [[NECallViewController alloc] initWithOtherMember:invitor isCalled:YES type:type];
        if ([[UIViewController topShowViewController] isKindOfClass:[ML_SessionViewController class]]) {
            
            callVC.response = response;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.25;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [[UIViewController topShowViewController].navigationController.view.layer addAnimation:transition forKey:nil];
            [[UIViewController topShowViewController].navigationController pushViewController:callVC animated:NO];
            
        } else {
            
            // 弹窗接听
            __block ML_SHowView *showview = [[ML_SHowView alloc] initWithFrame:[UIViewController topShowViewController].view.bounds];
            
            [showview setDic:dic[@"otherInfo"] sureBtClcik:^{
                
                if ([response.status intValue] == 106) {
                    
                    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
                        
                    }];
                    
                    NSString *str = response.msg;
                    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
                    tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : str?:@"余额不足，请充值！"};
                    
                    showview.cancel_block();
                    return;
                }
                
                callVC.autoJie = YES;
                callVC.response = response;
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.25;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [[UIViewController topShowViewController].navigationController.view.layer addAnimation:transition forKey:nil];
                [[UIViewController topShowViewController].navigationController pushViewController:callVC animated:NO];

            } cancelClick:^{
                
                [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
                    
                }];
                
            }];
            [showview show];
        }
        
    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {
        
    }];
    
}

- (BOOL)shouldResponseBusy
{
    MLTabbarViewController *tabVC = [MLTabbarViewController instance];
    [tabVC.view endEditing:YES];
    UINavigationController *nav = tabVC.selectedViewController;
    return [nav.topViewController isKindOfClass:[NECallViewController class]];
}


#pragma mark - NIMNetCallManagerDelegate
//- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage
//- (void)onInvited:(NSString *)invitor
//          userIDs:(NSArray<NSString *> *)userIDs
//      isFromGroup:(BOOL)isFromGroup
//          groupID:(nullable NSString *)groupID
//             type:(NERtcCallType)type
//       attachment:(nullable NSString *)attachment
//{
//    MLTabbarViewController *tabVC = [MLTabbarViewController instance];
//    [tabVC.view endEditing:YES];
//    UINavigationController *nav = tabVC.selectedViewController;
//
//    if ([self shouldResponseBusy]){
//
//        [[NIMAVChatSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
//    }else {
//        if ([self shouldFireNotification:caller]) {
//            NSString *text = [self textByCaller:caller
//                                           type:type];
//            [_notifier start:text];
//        }
//        UIViewController *vc;
//        switch (type) {
//            case NIMNetCallTypeVideo:{
//                vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
//            }
//                break;
//            case NIMNetCallTypeAudio:{
//                vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
//            }
//                break;
//            default:
//                break;
//        }
//        if (!vc) {
//            return;
//        }
//
//        // 由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.25;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromTop;
//        [nav.view.layer addAnimation:transition forKey:nil];
//        nav.navigationBarHidden = YES;
//        if (nav.presentedViewController) {
//            // fix bug MMC-1431
//            [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        }
//        [nav pushViewController:vc animated:NO];
//    }
//}

//- (void)onHangup:(UInt64)callID
//              by:(NSString *)user
//{
//    [_notifier stop];
//}

//- (void)onRTSRequest:(NSString *)sessionID
//                from:(NSString *)caller
//            services:(NSUInteger)types
//             message:(NSString *)info
//{
//    if ([self shouldResponseBusy]) {
//        [[NIMAVChatSDK sharedSDK].rtsManager responseRTS:sessionID accept:NO option:nil completion:nil];
//    }
//    else {
//
//        if ([self shouldFireNotification:caller]) {
//            NSString *text = [self textByCaller:caller];
//            [_notifier start:text];
//        }
//        NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:sessionID
//                                                                                            peerID:caller
//                                                                                             types:types
//                                                                                              info:info];
//        if (@available(iOS 13, *)) {
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        }
//        [self presentModelViewController:vc];
//    }
//}


- (void)presentModelViewController:(UIViewController *)vc
{
    MLTabbarViewController *tab = [MLTabbarViewController instance];
    [tab.view endEditing:YES];
    if (tab.presentedViewController) {
        __weak MLTabbarViewController *wtabVC = tab;
        [tab.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [wtabVC presentViewController:vc animated:NO completion:nil];
        }];
    }else{
        [tab presentViewController:vc animated:NO completion:nil];
    }
}

- (void)onRTSTerminate:(NSString *)sessionID
                    by:(NSString *)user
{
    [_notifier stop];
}


#pragma mark - NIMBroadcastManagerDelegate
- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage
{
    [self makeToast:broadcastMessage.content];
}

#pragma mark - format
//- (NSString *)textByCaller:(NSString *)caller type:(NIMNetCallMediaType)type
//{
//    NSString *action = type == NIMNetCallMediaTypeAudio ? @"音频".ntes_localized : @"视频".ntes_localized;
//    NSString *text = [NSString stringWithFormat:@"%@%@%@",
//                              @"你收到了一个".ntes_localized,
//                              action,
//                              @"聊天请求".ntes_localized];
//    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:caller option:nil];
//    if ([info.showName length])
//    {
//        text = [NSString stringWithFormat:@"%@%@%@%@",
//                info.showName,
//                @"向你发起了一个".ntes_localized,
//                action,
//                @"聊天请求".ntes_localized];
//    }
//    return text;
//}


//- (NSString *)textByCaller:(NSString *)caller
//{
//    NSString *text = @"你收到了一个白板请求".ntes_localized;
//    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:caller option:nil];
//    if ([info.showName length])
//    {
//        text = [NSString stringWithFormat:@"%@%@",
//                info.showName,
//                @"向你发起了一个白板请求".ntes_localized];
//    }
//    return text;
//}

- (BOOL)shouldFireNotification:(NSString *)callerId
{
    //退后台后 APP 存活，然后收到通知
    BOOL should = YES;
 
    //消息不提醒
    id<NIMUserManager> userManager = [[NIMSDK sharedSDK] userManager];
    if (![userManager notifyForNewMsg:callerId])
    {
        should = NO;
    }
    
    //当前在正处于免打扰
    id<NIMApnsManager> apnsManager = [[NIMSDK sharedSDK] apnsManager];
    NIMPushNotificationSetting *setting = [apnsManager currentSetting];
    if (setting.noDisturbing)
    {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger now = components.hour * 60 + components.minute;
        NSInteger start = setting.noDisturbingStartH * 60 + setting.noDisturbingStartM;
        NSInteger end = setting.noDisturbingEndH * 60 + setting.noDisturbingEndM;

        //当天区间
        if (end > start && end >= now && now >= start)
        {
            should = NO;
        }
        //隔天区间
        else if(end < start && (now <= end || now >= start))
        {
            should = NO;
        }
    }

    return should;
}

- (NIMSessionViewController *)currentSessionViewController
{
    UINavigationController *nav = [MLTabbarViewController instance].selectedViewController;
    for (UIViewController *vc in nav.viewControllers)
    {
        if ([vc isKindOfClass:[NIMSessionViewController class]])
        {
            return (NIMSessionViewController *)vc;
        }
    }
    return nil;
}

- (void)makeToast:(NSString *)content
{
    [[MLTabbarViewController instance].selectedViewController.view makeToast:content duration:2.0 position:CSToastPositionCenter];
}


@end
