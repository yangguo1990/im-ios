//
//  ML_SessionViewController.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "ML_SessionViewController.h"
@import MobileCoreServices;
@import AVFoundation;
#import "Reachability.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESCustomSysNotificationSender.h"
#import "NTESSessionConfig.h"
#import "NIMMediaItem.h"
#import "NTESSessionMsgConverter.h"
#import "NTESFileLocationHelper.h"
#import "NTESSessionMsgConverter.h"
#import "UIView+Toast.h"
#import "NTESSnapchatAttachment.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESFileTransSelectViewController.h"
#import "NTESChartletAttachment.h"
#import "NTESGalleryViewController.h"
#import "NTESVideoViewController.h"
#import "NTESFilePreViewController.h"
#import "NTESAudio2TextViewController.h"
#import "NSDictionary+NTESJson.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NTESSessionRemoteHistoryViewController.h"
#import "NIMNormalTeamCardViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESPersonalCardViewController.h"
#import "NTESSessionSnapchatContentView.h"
#import "NTESSessionLocalHistoryViewController.h"
#import "NIMContactSelectViewController.h"
#import "SVProgressHUD.h"
#import "NTESSessionCardViewController.h"
#import "NTESFPSLabel.h"
#import "UIAlertView+NTESBlock.h"
#import "NIMKit.h"
#import "NTESSessionUtil.h"
#import "NIMKitMediaFetcher.h"
#import "NIMKitLocationPoint.h"
#import "NIMLocationViewController.h"
#import "NIMKitInfoFetchOption.h"
#import "NTESSubscribeManager.h"
#import "NTESTeamMeetingCallerInfo.h"
#import "NIMInputAtCache.h"
#import "NTESRedPacketAttachment.h"
#import "NTESRedPacketTipAttachment.h"
#import "NTESCellLayoutConfig.h"
#import "NTESTeamReceiptSendViewController.h"
#import "NTESTeamReceiptDetailViewController.h"
#import "NIMSuperTeamCardViewController.h"
#import "NTESMulSelectFunctionBar.h"
#import "NTESMergeForwardSession.h"
#import "NTESSessionMultiRetweetContentView.h"
#import "NTESMergeMessageViewController.h"
#import "NTESMessageRetrieveResultVC.h"
#import "NTESMessagePinListViewController.h"
#import "NIMCommonTableData.h"
#import "NIMReplyContentView.h"
#import "NTESThreadTalkSessionViewController.h"
#import "UIView+NIMToast.h"
#import "NTESWhiteboardAttachment.h"
#import "NECallViewController.h"
#import "NTESTimerHolder.h"
#import "NEGroupCallVC.h"
#import "ML_XuanAlbumView.h"
#import "LDSGiftView.h"
#import "LDSGiftCellModel.h"
#import "LDSGiftModel.h"
#import "LDSGiftShowManager.h"
#import "ML_RequestManager.h"
#import "LVRollingScreenView.h"

NSString *kNTESDemoRevokeMessageFromMeNotication = @"kNTESDemoRevokeMessageFromMeNotication";

@interface ML_SessionViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UISearchControllerDelegate,
NIMSystemNotificationManagerDelegate,
NIMMediaManagerDelegate,
NTESTimerHolderDelegate,
NIMEventSubscribeManagerDelegate,
NIMTeamCardViewControllerDelegate,
NIMMessagePinListViewControllerDelegate,
NIMChatExtendManagerDelegate,
LDSGiftViewDelegate>

@property (nonatomic,strong)    NTESCustomSysNotificationSender *notificaionSender;
@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;
@property (nonatomic,strong)    UIImagePickerController *imagePicker;
@property (nonatomic,strong)    NTESTimerHolder         *titleTimer;
@property (nonatomic,strong)    UIView *currentSingleSnapView;
@property (nonatomic,strong)    NTESFPSLabel *fpsLabel;
@property (nonatomic,strong)    NIMKitMediaFetcher *mediaFetcher;
@property (nonatomic,strong)    NSMutableArray *selectedMessages;
@property (nonatomic,strong)    NTESMulSelectFunctionBar *mulSelectedSureBar;
@property (nonatomic,strong)    UIButton *mulSelectCancelBtn;
@property (nonatomic,strong)    NTESMergeForwardSession *mergeForwardSession;
@property (nonatomic,strong)    UISearchController * searchController;
@property (nonatomic,strong)    NTESMessageRetrieveResultVC * resultVC;
@property(nonatomic,strong) LDSGiftView *giftView;
//@property(nonatomic,strong) UIButton *backBtn;
@end


@implementation ML_SessionViewController

#pragma mark - LDSGiftViewDelegate
- (void)giftViewSendGiftInView:(LDSGiftView *)giftView data:(LDSGiftCellModel *)model {
    
    NSLog(@"点击-- %@",model.name);


}

- (LDSGiftView *)giftView {
    if (_giftView == nil) {
        _giftView = [[LDSGiftView alloc] init];
        _giftView.delegate = self;
        _giftView.userId = self.userId;
        NSArray *giftArr = [ML_AppConfig sharedManager].giftArr;
        _giftView.dataArray = giftArr;
        _giftView.giveType = @(1);
        _giftView.relationId = @"0";
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        
//        NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        option.session = self.session;
        option.forbidaAlias = YES;
        _giftView.userName = [[NIMKit sharedKit].provider infoByUser:self.userId option:option].showName;
            
    }
    return _giftView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return YES;
}
- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
    
    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _notificaionSender  = [[NTESCustomSysNotificationSender alloc] init];
    
     self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self setUpNavItem];
    NSLog(@"enter session, id = %@",self.session.sessionId);
//    [self setupNormalNav];
//    [self setUpNavItem];
    BOOL disableCommandTyping = self.disableCommandTyping || (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    
    if (!disableCommandTyping) {
        _titleTimer = [[NTESTimerHolder alloc] init];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }

    if ([[NTESBundleSetting sharedConfig] showFps])
    {
        self.fpsLabel = [[NTESFPSLabel alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.fpsLabel];
        self.fpsLabel.right = self.view.width;
        self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
    }
    
    if (self.session.sessionType == NIMSessionTypeP2P && !self.disableOnlineState)
    {
        //临时订阅这个人的在线状态
        [[NTESSubscribeManager sharedManager] subscribeTempUserOnlineState:self.session.sessionId];
        [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    }
    
    //删除最近会话列表中有人@你的标记
    [NTESSessionUtil removeRecentSessionMark:self.session type:NTESRecentSessionMarkTypeAt];
    
//    kSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{

//    self.sessionInputView.toolBar.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:246.0/255 alpha:1.0];
    self.sessionInputView.toolBar.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
//        self.sessionInputView.backgroundColor =  self.sessionInputView.toolBar.backgroundColor;
    
//    });
    
    
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    
    NSDictionary *oDic = userData.officialInfo[@"officialServInfo"];
    BOOL b = ([oDic[@"id"] intValue] == [self.userId intValue]);
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [btn addTarget:self action:@selector(sessionInputViewbottBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [self.view addSubview:btn];
        if (i == 0) {
            
            btn.hidden = ([ML_AppUtil isCensor] && !b);
            [btn setImage:kGetImage(@"icon_paizhao_30_CCC_nor") forState:UIControlStateNormal];
        } else if (i == 1) {
            btn.hidden = ([ML_AppUtil isCensor] || b);
            [btn setImage:kGetImage(@"icon_dayuyin_30_CCC_nor") forState:UIControlStateNormal];
        } else if (i == 2) {
            btn.hidden = b;
            [btn setImage:kGetImage(@"icon_shipin_30_nor") forState:UIControlStateNormal];
        } else if (i == 3) {
            btn.hidden = b;
            [btn setImage:kGetImage(@"icon_liwu_30_nor") forState:UIControlStateNormal];
        }
    }

    //批量转发
    _mergeForwardSession = [[NTESMergeForwardSession alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRevokeMessageFromMe:)
                                                 name:kNTESDemoRevokeMessageFromMeNotication
                                               object:nil];

}

- (void)sessionInputViewbottBtnClick:(UIButton *)btn
{
    
    //收回自定义输入框
    [self.sessionInputView endEditing:YES];
    
    [btn becomeFirstResponder];
    if (btn.tag-1000 == 0) {
        [self.interactor mediaPicturePressed];
    } else if (btn.tag-1000 == 1) {
        
//        [self onTapMediaItemAudioChat:nil];
        
        [self gotoCallVCWithUserId:self.session.sessionId isCalled:NO type:NERtcCallTypeAudio];
    } else if (btn.tag-1000 == 2) {
        
        [self gotoCallVCWithUserId:self.session.sessionId isCalled:NO type:NERtcCallTypeVideo];
    } else if (btn.tag-1000 == 3) {
        [self.giftView showGiftView];
    }
}

- (void)ML_backClickklb_la
{
    [self.navigationController popViewControllerAnimated:YES];
}

 - (void)setUpNavItem{
     
//     UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ML_NavViewHeight - 44, 50, 44)];
//     backBtn.titleLabel.font = kGetFont(16);
//     backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//     [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//     [backBtn addTarget:self action:@selector(ML_backClickklb_la) forControlEvents:UIControlEventTouchUpInside];
//     [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateNormal];
//     [self.customNavBar addSubview:backBtn];
//     self.backBtn = backBtn;
//
//     self.customNavBar.titleLabelColor = [UIColor blackColor];
//     self.customNavBar.titleLabelColorTextAlignment = NSTextAlignmentLeft;
//     self.customNavBar.titleLabelFont = [UIFont boldSystemFontOfSize:18];
     
     UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

     NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
  
     if (![self.userId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]) {
         
//         self.ML_titleLabel.textAlignment = NSTextAlignmentCenter;
//     } else {
         
         self.ML_titleLabel.textAlignment = NSTextAlignmentLeft;
         
         [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_sessionlist_more_normal")];
//         UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 60, backBtn.y, backBtn.width, backBtn.height)];
//         [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
//         [moreBtn setImage:[UIImage imageNamed:@"icon_sessionlist_more_normal"] forState:UIControlStateNormal];
//         [moreBtn setImage:[UIImage imageNamed:@"icon_sessionlist_more_pressed"] forState:UIControlStateHighlighted];
//         [self.customNavBar addSubview:moreBtn];
         
     }
     self.ML_titleLabel.text = self.sessionTitle;
     
 }

- (void)ML_rightItemClicked
{
    
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"userId" : self.userId} urlStr:@"user/whetherFocus"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
         
         [SVProgressHUD dismiss];
         NSArray<PopItemModel *> *Items = [PopItemModel ToFYProfileControllerWithIsla:[response.data[@"block"] boolValue]];
         kSelf2;
         [ML_XuanAlbumView popItems:Items action:^(NSInteger index) {
        
             if (index == 0) {
                 
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"清空聊天记录？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
                 [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
                     switch (alertIndex) {
                         case 1:
                         {
                             NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
                             options.removeOtherClients = YES;
                             [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:weakself2.session options:options completion:^(NSError * _Nullable error) {
                                 if (error) {
                                     [weakself2.view makeToast:[NSString stringWithFormat: @"删除失败:%@", error.localizedDescription]];
                                     return;
                                 }
                                 [weakself2 refreshMessages];
                             }];
                             
                             break;
                         }
                         default:
                             break;
                     }
                 }];
                 
                 
                 
             } else {
                 
                 [weakself ML_PopAction:index pDic:@{@"userId" : weakself2.userId, @"dongId" : @"", @"block" : @([response.data[@"block"] boolValue]), @"showInfo" : @"1"}];
             }
         }];
         
     } error:^(MLNetworkResponse *response) {

     } failure:^(NSError *error) {
         
     }];
    
    
}


- (void)dealloc
{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    if (self.session.sessionType == NIMSessionTypeP2P && !self.disableOnlineState)
    {
        [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
        [[NTESSubscribeManager sharedManager] unsubscribeTempUserOnlineState:self.session.sessionId];
    }
    [_fpsLabel invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNTESDemoRevokeMessageFromMeNotication object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.fpsLabel.right = self.view.width;
    self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
  
    self.mulSelectedSureBar.frame = self.sessionInputView.frame;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];

}

- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - NIMTeamCardViewControllerDelegate
- (void)NIMTeamCardVCDidSetTop:(BOOL)isTop {
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session];
    if (isTop) {
        if (!recent) {
            [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:self.session];
        }
        NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:self.session];
        [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:nil];
    } else {
        if (recent) {
            NIMStickTopSessionInfo *stickTopInfo = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:self.session];
            [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:stickTopInfo completion:nil];
        } else {}
    }
}

#pragma mark - NIMEventSubscribeManagerDelegate
- (void)onRecvSubscribeEvents:(NSArray *)events
{
    for (NIMSubscribeEvent *event in events) {
        if ([event.from isEqualToString:self.session.sessionId]) {
            [self refreshSessionSubTitle:[NTESSessionUtil onlineState:self.session.sessionId detail:YES]];
        }
    }
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict jsonInteger:NTESNotifyID] == NTESCommandTyping && self.session.sessionType == NIMSessionTypeP2P && [notification.sender isEqualToString:self.session.sessionId])
        {
            
            self.ML_titleLabel.text = @"对方正在输入...".ntes_localized;
//            [self refreshSessionTitle:@"正在输入...".ntes_localized];
            [_titleTimer startTimer:5
                           delegate:self
                            repeats:NO];
        }
    }
    
    
}

- (void)changeLeftBarBadge:(NSInteger)unreadCount
{
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
    NSDictionary *newestMsgDic = dic1[@"newestMsg"];
          
    unreadCount += [newestMsgDic[@"notRead"] intValue];
    
    for (UIView *laV in self.ML_backBtn.subviews) {
        if (laV.tag == 10) {
            [laV removeFromSuperview];
            break;
        }
    }
    
    if (unreadCount) {
        UILabel *bageView = [[UILabel alloc] initWithFrame:CGRectMake(25, 9, 23, 23)];
        bageView.backgroundColor = [UIColor redColor];
        bageView.layer.borderWidth = 1;
        bageView.layer.borderColor = [kGetColor(@"#ffffff") CGColor]; // 边框
        bageView.font = kGetFont(14);
        bageView.textAlignment = NSTextAlignmentCenter;
        bageView.textColor = [UIColor whiteColor];
        bageView.text = [self.ML_backBtn currentTitle];
        bageView.layer.cornerRadius = bageView.height / 2;
        bageView.tag = 10;
        bageView.layer.masksToBounds = YES;
        [self.ML_backBtn addSubview:bageView];
        bageView.text = [NSString stringWithFormat:@"%ld", unreadCount];
        if (unreadCount > 99) {
            bageView.text = @"...";
        }
    }
    
}

#pragma mark - NIMMediaManagerDelegate
- (void)playAudio:(NSString *)filePath progress:(float)value
{
    NSLog(@"playAudio progress:%@", @(value));
}


#pragma mark - UISearchControllerDelegate

- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    [self refreshSessionTitle:self.sessionTitle];
}


- (NSString *)sessionTitle
{
    if ([self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        return  @"我的电脑".ntes_localized;
    }
    return [super sessionTitle];
}

- (NSString *)sessionSubTitle
{
    if (self.session.sessionType == NIMSessionTypeP2P && ![self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        return [NTESSessionUtil onlineState:self.session.sessionId detail:YES];
    }
    return @"";
}

- (void)onTextChanged:(id)sender
{
    [_notificaionSender sendTypingState:self.session];
}

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId
{
    NTESChartletAttachment *attachment = [[NTESChartletAttachment alloc] init];
    attachment.chartletId = chartletId;
    attachment.chartletCatalog = catalogId;
    [self sendMessage:[NTESSessionMsgConverter msgWithChartletAttachment:attachment]];
}

#pragma mark - PIN界面回调

- (void)pinListViewController:(NIMMessagePinListViewController *)pinListVC didRequestViewMessage:(NIMMessage *)message
{
    [self scrollToMessage:message];
}

- (void)pinListViewController:(NIMMessagePinListViewController *)pinListVC didRemovePinItem:(NIMMessagePinItem *)item forMessage:(NIMMessage *)message
{
    [self uiUnpinMessage:message];
}

#pragma mark - 文本消息
- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
{

    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.session.sessionId, @"type" : @"1", @"message" : text?:@""} urlStr:@"im/imPre"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        [super onSendText:text atUsers:atUsers];
        
    } error:^(MLNetworkResponse *response) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
    } failure:^(NSError *error) {

    }];
    
}

- (void)sendMessage:(NIMMessage *)message
{
    if ([[NTESBundleSetting sharedConfig] enableLocalAnti] && message.messageType == NIMMessageTypeText)
    {
        NIMLocalAntiSpamCheckOption *checkOption = [[NIMLocalAntiSpamCheckOption alloc] init];
        checkOption.content = message.text;
        checkOption.replacement = @"*";
        NSError *error = nil;
        NIMLocalAntiSpamCheckResult *result = [[NIMSDK sharedSDK].antispamManager checkLocalAntispam:checkOption error:&error];
        if (error)
        {
            [self.view makeToast:@"本地反垃圾失败".ntes_localized];
        }
        else
        {
            switch (result.type) {
                case NIMAntiSpamOperateFileNotExists:
                    break;
                case NIMAntiSpamResultLocalReplace:
                    message.text = result.content;
                    break;
                case NIMAntiSpamResultLocalForbidden:
                    [self.view makeToast:@"** 该消息被屏蔽 **".ntes_localized];
                    return;
                case NIMAntiSpamResultServerForbidden:
                {
                    NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc] init];
                    option.hitClientAntispam = YES;
                    message.antiSpamOption = option;
                }
                    break;
                case NIMAntiSpamResultNotHit:
                    break;
                default:
                    break;
            }
        }
    }
    
  
    [super sendMessage:message];
}


#pragma mark - 消息发送时间截获
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if (error) {
        switch (error.code) {
            case 20000:
            {
                kplaceToast(Localized(@"参数非法！", nil));
                break;
            }
            case 20001:
            {
                kplaceToast(Localized(@"您的账户被封禁！", nil));
                break;
            }
            case 20002:
            {
                kplaceToast(Localized(@"对方账户被封禁！", nil));
                break;
            }
            case 20003:
            {
                kplaceToast(Localized(@"对方账号已注销！", nil));
                break;
            }
            case 20004:
            {
                kplaceToast(Localized(@"您没有IM权限！", nil));
                break;
            }
            case 20005:
            {
                kplaceToast(Localized(@"对方没有IM权限！", nil));
                break;
            }
            case 20006:
            {
                kplaceToast(Localized(@"你已被对方拉黑！", nil));
                break;
            }
            case 20007:
            {
                kplaceToast(Localized(@"对方已被你拉黑！", nil));
                break;
            }
            case 20008:
            {
                kplaceToast(Localized(@"对方已开启勿扰！", nil));
                break;
            }
            case 20009:
            {
                kplaceToast(Localized(@"身份相同，不能相互通信！", nil));
                break;
            }
            case 20010:
            {
                kplaceToast(Localized(@"主播与主播不能相互通信！", nil));
                break;
            }
            case 20011:
            {
                kplaceToast(Localized(@"消息内容不能为空！", nil));
                break;
            }
            case 20012:
            {
                kplaceToast(Localized(@"消息涉嫌违规，无法发送！", nil));
                break;
            }
            case 20013:
            {
                kplaceToast(Localized(@"今日免费额度用尽！", nil));
                break;
            }
            case 20014:
            {
                kplaceToast(Localized(@"金币不足，无法发送！", nil));
                break;
            }
            case 20015:
            {
                kplaceToast(Localized(@"不支持消息类型！", nil));
                break;
            }
            case 20016:
            {
                kplaceToast(Localized(@"不支持回调类型！", nil));
                break;
            }
            case 20017:
            {
                kplaceToast(Localized(@"请先关闭勿扰模式才能发消息！", nil));
                break;
            }
            case 20018:
            {
                kplaceToast(Localized(@"需要对方回复才能再次发起消息！", nil));
                break;
            }
            default:
                break;
        }
        NSLog(@"发送结果报错 =======%@", error);
    } else{
        
        if (message.messageType != 100) {
            
//            UserInfoData * su = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//            NSLog(@"dfasdf===adsf=as=f==%@==%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId, su.token);
            
            NSMutableDictionary *PDic = [NSMutableDictionary dictionaryWithDictionary:@{@"fromAccount" : [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId, @"toAccount" : self.userId?:@"", @"body" : message.text?:@"", @"msgTimestamp" : [self giveformatter]}];

            if (message.messageType == NIMMessageTypeText) {
                [PDic setObject:@"1" forKey:@"eventType"];
                [PDic setObject:@{} forKey:@"attach"];
            } else if (message.messageType == NIMMessageTypeAudio) {
                NIMAudioObject *obj = (NIMAudioObject *)message.messageObject;
                
                [PDic setObject:@"2" forKey:@"eventType"];
                [PDic setObject:@{@"md5" : obj.md5, @"url" : obj.url, @"dur" : [NSString stringWithFormat:@"%ld", (long)obj.duration]} forKey:@"attach"];
                
                
                
                      ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.session.sessionId, @"type" : @"2", @"message" : @""} urlStr:@"im/imPre"];
              
                      kSelf;
                      [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                          weakself.sessionInputView.isFaStr = nil;
                      } error:^(MLNetworkResponse *response) {
                          weakself.sessionInputView.isFaStr = response.msg?:@"0";
                      } failure:^(NSError *error) {

                      }];

                
            }

            
            
            kSelf;
            [ML_RequestManager requestPath:@"im/imCallback" parameters:PDic doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
                    
                if ([responseObject[@"code"] intValue] == 0) {
                    
                } else {
                    
                }
                
            } failure:^(NSError * _Nonnull error) {
                
            }];;
            
        }
        
    }
    
    [super sendMessage:message didCompleteWithError:error];

}


#pragma mark - 石头剪子布
- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item
{
    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
    attachment.value = arc4random() % 3 + 1;
    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
}

#pragma mark - 实时语音
- (void)onTapMediaItemAudioChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        NECallViewController *callVC = [[NECallViewController alloc] initWithOtherMember:self.session.sessionId isCalled:NO type:NERtcCallTypeAudio];
        [self.navigationController presentViewController:callVC animated:YES completion:nil];
    }
}

#pragma mark - 视频聊天
- (void)onTapMediaItemVideoChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
//        NECallViewController *callVC = [[NECallViewController alloc] initWithOtherMember:self.session.sessionId isCalled:NO type:NERtcCallTypeVideo];
//        [self.navigationController presentViewController:callVC animated:YES completion:nil];
        [self gotoCallVCWithUserId:self.session.sessionId isCalled:NO type:NERtcCallTypeVideo];
    }
}

#pragma mark - 群组会议
//点击按钮发起多人视频通话
- (void)onTapMediaItemTeamMeeting:(NIMMediaItem *)item
{
    if ([self checkRTSCondition])
    {
        NIMTeam *team = nil;
        NIMKitTeamType teamType = NIMKitTeamTypeNomal;
        switch (self.session.sessionType) {
            case NIMSessionTypeTeam:
                team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
                teamType = NIMKitTeamTypeNomal;
                break;
            case NIMSessionTypeSuperTeam:
                team = [[NIMSDK sharedSDK].superTeamManager teamById:self.session.sessionId];
                teamType = NIMKitTeamTypeSuper;
                break;
            default:
                break;
        }
        if (!team) {
            return;
        }
        
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
        config.session = self.session;
        config.teamType = teamType;
        config.teamId = team.teamId;
        config.filterIds = @[currentUserID];
        config.needMutiSelected = YES;
        config.maxSelectMemberCount = 8;
        config.showSelectDetail = YES;
        NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
        __weak typeof(self) weakSelf = self;
        vc.finshBlock = ^(NSArray * memeber){
            NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
            NEGroupCallVC *groupVC = [[NEGroupCallVC alloc] initWithCaller:me otherMembers:memeber isCalled:NO];
            groupVC.teamId = weakSelf.session.sessionId;
            groupVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:groupVC animated:NO completion:nil];
        };;
        [vc show];
    }
}


#pragma mark - 文件传输
- (void)onTapMediaItemFileTrans:(NIMMediaItem *)item
{
    NTESFileTransSelectViewController *vc = [[NTESFileTransSelectViewController alloc]
                                             initWithNibName:nil bundle:nil];
    __weak typeof(self) wself = self;
    __weak typeof(vc)   wVC = vc;
    vc.completionBlock = ^void(id sender,NSString *ext){
        if ([sender isKindOfClass:[NSString class]]) {
            [wself sendMessage:[NTESSessionMsgConverter msgWithFilePath:sender] completion:^(NSError *err) {
                if(wVC) {
                    [wself.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else if ([sender isKindOfClass:[NSData class]]){
            [wself sendMessage:[NTESSessionMsgConverter msgWithFileData:sender extension:ext]];
            if(wVC) {
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 阅后即焚
- (void)onTapMediaItemSnapChat:(NIMMediaItem *)item
{
    UIActionSheet *sheet;
    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCamraAvailable) {
        sheet = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择", nil).ntes_localized delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized destructiveButtonTitle:nil otherButtonTitles:Localized(@"从相册中选取", nil).ntes_localized,Localized(@"拍照", nil).ntes_localized,nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择", nil).ntes_localized delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized destructiveButtonTitle:nil otherButtonTitles:Localized(@"从相册中选取", nil).ntes_localized,nil];
    }
    __weak typeof(self) wself = self;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                //相册
                [wself.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images, NSString *path, PHAssetMediaType type){
                    if (images.count) {
                        [wself sendSnapchatMessage:images.firstObject];
                    }
                    if (path) {
                        [wself sendSnapchatMessagePath:path];
                    }
                }];
                
            }
                break;
            case 1:{
                //相机
                [wself.mediaFetcher fetchMediaFromCamera:^(NSString *path, UIImage *image) {
                    if (image) {
                        [wself sendSnapchatMessage:image];
                    }
                }];
            }
                break;
            default:
                return;
        }
    }];
}

- (void)sendSnapchatMessagePath:(NSString *)path
{
    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
    [attachment setImageFilePath:path];
    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
}

- (void)sendSnapchatMessage:(UIImage *)image
{
    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
    [attachment setImage:image];
    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
}

#pragma mark - 白板
//- (void)onTapMediaItemWhiteBoard:(NIMMediaItem *)item
//{
//    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:nil
//                                                                                        peerID:self.session.sessionId
//                                                                                         types:NIMRTSServiceReliableTransfer | NIMRTSServiceAudio
//                                                                                          info:@"白板演示"];
//    if (@available(iOS 13, *)) {
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    }
//    [self presentViewController:vc animated:NO completion:nil];
//}



#pragma mark - 提示消息
- (void)onTapMediaItemTip:(NIMMediaItem *)item
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"输入提醒".ntes_localized delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized otherButtonTitles:Localized(@"确定", nil).ntes_localized, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    __weak typeof(self) weakSelf = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                UITextField *textField = [alert textFieldAtIndex:0];
                NIMMessage *message = [NTESSessionMsgConverter msgWithTip:textField.text];
                [weakSelf sendMessage:message];

            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 红包
- (void)onTapMediaItemRedPacket:(NIMMediaItem *)item
{
//    [[NTESRedPacketManager sharedManager] sendRedPacket:self.session];
}

#pragma mark - 群已读回执
- (void)onTapMediaItemTeamReceipt:(NIMMediaItem *)item
{
    NTESTeamReceiptSendViewController *vc = [[NTESTeamReceiptSendViewController alloc] initWithSession:self.session];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 菜单

- (void)onTapMenuItemReply:(NIMMediaItem *)item
{
    NIMMessage *menuMessage = [self messageForMenu];
    if ([self.sessionConfig respondsToSelector:@selector(setThreadMessage:)])
    {
        [self.sessionConfig setThreadMessage:menuMessage];
    }
    
    [self.advanceMenu dismiss];
    [self.sessionInputView refreshStatus:NIMInputStatusText];
    [self.sessionInputView.toolBar.inputTextView becomeFirstResponder];
    [self.sessionInputView refreshReplyedContent:menuMessage];
    [self.sessionInputView sizeToFit];
    if (self.session.sessionType != NIMSessionTypeP2P &&
        menuMessage)
    {
        [self.sessionInputView addAtItems:@[[NSString stringWithFormat:@"%@", menuMessage.from]]];
    }
}

- (void)onTapMenuItemForword:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];
    NIMMessage *message = [self messageForMenu];
    message.setting.teamReceiptEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self selectForwardSessionCompletion:^(NIMSession *targetSession) {
        [weakSelf forwardMessage:message toSession:targetSession];
    }];
}


- (void)onTapMenuItemMark:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];
    NIMMessage *message = [self messageForMenu];
    NSData *messageData = [NIMSDK.sharedSDK.conversationManager encodeMessageToData:message];
    NIMAddCollectParams *params = [[NIMAddCollectParams alloc] init];
    params.data = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    params.type = 1;
    params.uniqueId = message.messageId.MD5String;
    [[NIMSDK sharedSDK].chatExtendManager addCollect:params completion:^(NSError * _Nullable error, NIMCollectInfo * _Nullable collectInfo) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"收藏失败".ntes_localized];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"已收藏".ntes_localized];
    }];
}

- (void)onTapMenuItemPin:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];
    NIMMessage *message = [self messageForMenu];
    NIMMessagePinItem *pinItem = [[NIMMessagePinItem alloc] initWithMessage:message];
    
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatExtendManager addMessagePin:pinItem completion:^(NSError * _Nullable error, NIMMessagePinItem * _Nullable item) {
        if (!wself) {
            return;
        }
        __strong typeof(wself) sself = wself;
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"添加失败".ntes_localized];
            return;
        }
        [sself uiPinMessage:message];
    }];
}

- (void)onTapMenuItemUnpin:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];
    NIMMessage *message = [self messageForMenu];
    NIMMessagePinItem *pinItem = [NIMSDK.sharedSDK.chatExtendManager pinItemForMessage:message];
    
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatExtendManager removeMessagePin:pinItem completion:^(NSError * _Nullable error, NIMMessagePinItem * _Nullable item) {
        if (!wself) {
            return;
        }
        __strong typeof(wself) sself = wself;
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"取消标记失败".ntes_localized];
            return;
        }
        [sself uiUnpinMessage:message];
    }];
    
}

- (void)onTapMenuItemRevoke:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];
    NIMMessage *message = [self messageForMenu];
    BOOL enableRevokePostscript = [[NTESBundleSetting sharedConfig] enableRevokeMsgPostscript];
    if (enableRevokePostscript) {
        [self doShowInputRevokePostscriptAlert:message];
    } else {
        [self doRevokeMessage:message postscript:nil];
    }
}

- (void)doShowInputRevokePostscriptAlert:(NIMMessage *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"撤回附言"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入附言";
    }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:Localized(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *input = alertVC.textFields.firstObject;
        [weakSelf doRevokeMessage:message postscript:input.text];
    }];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)doRevokeMessage:(NIMMessage *)message postscript:(NSString *)postscript{
    __weak typeof(self) weakSelf = self;
    NSString *collapseId = message.apnsPayload[@"apns-collapse-id"];
    NSDictionary *payload = @{
        @"apns-collapse-id": collapseId ? : @"",
    };
    NIMRevokeMessageOption *option = [[NIMRevokeMessageOption alloc] init];
    option.apnsContent = @"撤回一条消息";
    option.apnsPayload = payload;
    option.shouldBeCounted = ![[NTESBundleSetting sharedConfig] isIgnoreRevokeMessageCount];
    option.postscript = postscript;
    [[NIMSDK sharedSDK].chatManager revokeMessage:message option:option completion:^(NSError * _Nullable error) {
        if (error) {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"发送时间超过2分钟的消息，不能被撤回", nil).ntes_localized delegate:nil cancelButtonTitle:Localized(@"确定", nil).ntes_localized otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSLog(@"revoke message eror code %zd",error.code);
                [weakSelf.view makeToast:@"消息撤回失败，请重试".ntes_localized duration:2.0 position:CSToastPositionCenter];
            }
        } else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[@"msg"] = message;
            userInfo[@"postscript"] = postscript;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNTESDemoRevokeMessageFromMeNotication
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }];
}

- (void)onRevokeMessageFromMe:(NSNotification *)note {
    NIMMessage *message = note.userInfo[@"msg"];
    NSString *postscript = note.userInfo[@"postscript"];
    if (message) {
        NIMMessageModel *model = [self uiDeleteMessage:message];
        NIMMessage *tip = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevokedLocal:postscript]];
        tip.timestamp = model.messageTime;
        [self uiInsertMessages:@[tip]];
        
        tip.timestamp = message.timestamp;
        // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
        [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
    }
}

- (void)onTapMenuItemDelete:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];

    NIMMessage *message    = [self messageForMenu];
    BOOL deleteFromServer = [NTESBundleSetting sharedConfig].isDeleteMsgFromServer;
    if (deleteFromServer)
    {
        __weak typeof(self) wSelf = self;
        [[NIMSDK sharedSDK].conversationManager deleteMessageFromServer:message
                                                                    ext:@"扩展字段"
                                                             completion:^(NSError * _Nullable error)
        {
            if (error)
            {
                return;
            }
            
            [wSelf uiDeleteMessage:message];
        }];
    }
    else
    {
        BOOL isDeleteFromDB = [NTESBundleSetting sharedConfig].isDeleteMsgFromDB;
        NIMDeleteMessageOption *option = [[NIMDeleteMessageOption alloc] init];
        option.removeFromDB = isDeleteFromDB;
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message option:option];
        [self uiDeleteMessage:message];
    }
}

- (void)onTapMenuItemMutiSelect:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];

    [self switchUIWithSessionState:NIMKitSessionStateSelect];
}

- (void)onTapMenuItemAudio2Text:(NIMMediaItem *)item
{
    [self.advanceMenu dismiss];

    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) wself = self;
    NTESAudio2TextViewController *vc = [[NTESAudio2TextViewController alloc] initWithMessage:message];
    vc.completeHandler = ^(void){
        [wself uiUpdateMessage:message];
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败".ntes_localized duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短".ntes_localized duration:0.2f position:CSToastPositionCenter];
}

#pragma mark - Cell事件
- (BOOL)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if ([eventName isEqualToString:NIMKitEventNameTapRepliedContent])
    {
        handled = YES;
        NIMMessageModel *model = event.messageModel;
        NIMMessage *message = model.parentMessage;
        if (!message)
        {
            [self.view makeToast:@"父消息不存在".ntes_localized];
            return handled;
        }
        NTESThreadTalkSessionViewController *vc = [[NTESThreadTalkSessionViewController alloc] initWithThreadMessage:message];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMDemoEventNameOpenSnapPicture])
    {
        NIMCustomObject *object = event.messageModel.message.messageObject;
        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
        if(attachment.isFired){
            return handled;
        }
        UIView *sender = event.data;
        self.currentSingleSnapView = [NTESGalleryViewController alertSingleSnapViewWithMessage:object.message baseView:sender];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMDemoEventNameCloseSnapPicture])
    {
        //点击很快的时候可能会触发两次查看，所以这里不管有没有查看过 先强直销毁掉
        NIMCustomObject *object = event.messageModel.message.messageObject;
        UIView *senderView = event.data;
        [senderView dismissPresentedView:YES complete:nil];
        
        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
        if(attachment.isFired){
            return handled;
        }
        attachment.isFired  = YES;
        NIMMessage *message = object.message;
        if ([NTESBundleSetting sharedConfig].autoRemoveSnapMessage) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
            [self uiDeleteMessage:message];
        }else{
            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:nil];
            [self uiUpdateMessage:message];
        }
        [[NSFileManager defaultManager] removeItemAtPath:attachment.filepath error:nil];
        self.currentSingleSnapView = nil;
        handled = YES;
    }
//    else if([eventName isEqualToString:NIMDemoEventNameOpenRedPacket])
//    {
//        //红包功能因合作终止，暂时关闭
////        NIMCustomObject *object = event.messageModel.message.messageObject;
////        NTESRedPacketAttachment *attachment = (NTESRedPacketAttachment *)object.attachment;
////        [[NTESRedPacketManager sharedManager] openRedPacket:attachment.redPacketId from:event.messageModel.message.from session:self.session];
//        [self.view makeToast:@"红包功能暂时关闭" duration:1.5 position:CSToastPositionCenter];
//        handled = YES;
//    }
//    else if([eventName isEqualToString:NTESShowRedPacketDetailEvent])
//    {
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        NTESRedPacketTipAttachment *attachment = (NTESRedPacketTipAttachment *)object.attachment;
//        [[NTESRedPacketManager sharedManager] showRedPacketDetail:attachment.packetId];
//        handled = YES;
//    }
    else if ([eventName isEqualToString:NIMDemoEventNameOpenMergeMessage])
    {
        NIMMessage *message = event.messageModel.message;
        NTESMergeMessageViewController *vc = [[NTESMergeMessageViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:vc animated:YES];
        handled = YES;
    }
    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    return handled;
}

- (BOOL)onTapAvatar:(NIMMessage *)message{
    NSString *userId = [self messageSendSource:message];
    [self gotoInfoVC:userId];
    
    return YES;
}


- (BOOL)onLongPressAvatar:(NIMMessage *)message
{
    NSString *userId = [self messageSendSource:message];
    NIMSessionType sessionType = self.session.sessionType;
    if ((sessionType == NIMSessionTypeTeam || sessionType == NIMSessionTypeSuperTeam)
        && ![userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
    {
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        option.forbidaAlias = YES;
        
        NSString *nick = [[NIMKit sharedKit].provider infoByUser:userId option:option].showName;
        NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,nick,NIMInputAtEndChar];
        
        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
        item.uid  = userId;
        item.name = nick;
        [self.sessionInputView.atCache addAtItem:item];
        
        [self.sessionInputView.toolBar insertText:text];
    }
    return YES;
}

- (BOOL)onPressReadLabel:(NIMMessage *)message
{
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NTESTeamReceiptDetailViewController *vc = [[NTESTeamReceiptDetailViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (void)onSelectedMessage:(BOOL)selected message:(NIMMessage *)message {
    if (!_selectedMessages) {
        _selectedMessages = [NSMutableArray array];
    }
    if (selected) {
        [_selectedMessages addObject:message];
    } else {
        [_selectedMessages removeObject:message];
    }
}

- (void)onClickReplyButton:(NIMMessage *)message
{
    NTESThreadTalkSessionViewController *vc = [[NTESThreadTalkSessionViewController alloc] initWithThreadMessage:message];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString *)messageSendSource:(NIMMessage *)message {
    return message.from;
}

#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];
    item.size           = [object size];
    item.imagePath      = [object path];
    
    NIMSession *session = [self isMemberOfClass:[ML_SessionViewController class]]? self.session : nil;
    
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    NIMSession *session = [self isMemberOfClass:[ML_SessionViewController class]]? self.session : nil;
    
    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
    item.path = object.path;
    item.url  = object.url;
    item.session = session;
    item.itemId  = object.message.messageId;
    
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showLocation:(NIMMessage *)message
{
    NIMLocationObject *object = message.messageObject;
    NIMKitLocationPoint *locationPoint = [[NIMKitLocationPoint alloc] initWithLocationObject:object];
    NIMLocationViewController *vc = [[NIMLocationViewController alloc] initWithLocationPoint:locationPoint];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFile:(NIMMessage *)message
{
    NIMFileObject *object = message.messageObject;
    NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] initWithFileObject:object];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCall:(NIMMessage *)message {
    NIMRtcCallRecordObject *record = message.messageObject;
    NERtcCallType callType = record.callType == NIMRtcCallTypeVideo ? NERtcCallTypeVideo : NERtcCallTypeAudio;
    NECallViewController *callVC = [[NECallViewController alloc] initWithOtherMember:self.session.sessionId
                                                                            isCalled:NO
                                                                                type:callType];
    [self.navigationController presentViewController:callVC animated:YES completion:nil];
}

- (void)showCustom:(NIMMessage *)message
{
   //普通的自定义消息点击事件可以在这里做哦~
}

- (void)openSafari:(NSString *)link
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
    if (components)
    {
        if (!components.scheme)
        {
            //默认添加 http
            components.scheme = @"http";
        }
        [[UIApplication sharedApplication] openURL:[components URL]];
    }
}


#pragma mark - 导航按钮
- (void)enterPersonInfoCard:(id)sender{
    NTESSessionCardViewController *vc = [[NTESSessionCardViewController alloc] initWithSession:self.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)setupAlertActions {
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cloudMessageAction = [UIAlertAction actionWithTitle:@"云消息记录".ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NTESSessionRemoteHistoryViewController *vc = [[NTESSessionRemoteHistoryViewController alloc] initWithSession:weakSelf.session];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *searchLocalMessageAction = [UIAlertAction actionWithTitle:@"搜索本地消息记录".ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NTESSessionLocalHistoryViewController *vc = [[NTESSessionLocalHistoryViewController alloc] initWithSession:weakSelf.session];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *cleanLocalMessageAction = [UIAlertAction actionWithTitle:@"清空本地聊天记录".ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showDeleteSureVCWithTitle:@"确定清空聊天记录?".ntes_localized confirmBlock:^{
            BOOL removeRecentSession = [NTESBundleSetting sharedConfig].removeSessionWhenDeleteMessages;
            BOOL removeTable = [NTESBundleSetting sharedConfig].dropTableWhenDeleteMessages;
            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
            option.removeSession = removeRecentSession;
            option.removeTable = removeTable;
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:weakSelf.session
                                                                        option:option];
        }];
    }];
    
    UIAlertAction *cleanRemoteMessagesAction = [UIAlertAction actionWithTitle:@"清空远端聊天记录".ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showDeleteSureVCWithTitle:@"确定清空聊天记录?".ntes_localized confirmBlock:^{
            NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            options.removeOtherClients = YES;
            [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:weakSelf.session options:options completion:^(NSError * _Nullable error) {
                if (error) {
                    [weakSelf.view makeToast:[NSString stringWithFormat: @"删除失败:%@",error.localizedDescription]];
                    return;
                }
                [weakSelf refreshMessages];
            }];
        }];
    }];
    
    UIAlertAction *viewPinnedMessageAction = [UIAlertAction actionWithTitle:@"查看标记消息".ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NTESMessagePinListViewController *vc = [[NTESMessagePinListViewController alloc] initWithSession:weakSelf.session];
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil).ntes_localized style:UIAlertActionStyleCancel handler:nil];

    return @[cloudMessageAction,
             searchLocalMessageAction,
             cleanLocalMessageAction,
             cleanRemoteMessagesAction,
             viewPinnedMessageAction,
             cancel].mutableCopy;
}

- (void)showDeleteSureVCWithTitle:(NSString *)title confirmBlock:(void(^)(void))confirmBlock {
    UIAlertAction *sure = [UIAlertAction actionWithTitle:Localized(@"确定", nil).ntes_localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil).ntes_localized
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:sure];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)enterHistory:(id)sender{
    [self.view endEditing:YES];
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选择操作".ntes_localized
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *actions = [self setupAlertActions];
    for (UIAlertAction *action in actions) {
        [sheet addAction:action];
    }
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)enterTeamCard:(id)sender {
    NIMTeamCardViewController *vc = nil;
    NIMTeamCardViewControllerOption *option = [[NIMTeamCardViewControllerOption alloc] init];
    option.isTop = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:self.session] != nil;

    if (self.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team
                                                               session:self.session
                                                                option:option];
            vc.delegate = self;
        }else if(team.type == NIMTeamTypeAdvanced){
            vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:team
                                                                 session:self.session
                                                                  option:option];
            vc.delegate = self;
        }
    } else if (self.session.sessionType == NIMSessionTypeSuperTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].superTeamManager teamById:self.session.sessionId];
        vc = [[NIMSuperTeamCardViewController alloc] initWithTeam:team
                                                          session:self.session
                                                           option:option];
        vc.delegate = self;
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)enterSuperTeamCard:(id)sender{
    NIMTeam *team = [[NIMSDK sharedSDK].superTeamManager teamById:self.session.sessionId];
    NIMTeamCardViewControllerOption *option = [[NIMTeamCardViewControllerOption alloc] init];
    option.isTop = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:self.session] != nil;

    NIMSuperTeamCardViewController *vc = [[NIMSuperTeamCardViewController alloc] initWithTeam:team
                                                                                      session:self.session
                                                                                       option:option];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    
    if ([NTESSessionUtil canMessageBeForwarded:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"转发".ntes_localized action:@selector(forwardMessage:)]];
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"多选".ntes_localized action:@selector(multiSelect:)]];
    }
    
    if ([NTESSessionUtil canMessageBeRevoked:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:Localized(@"撤回", nil) action:@selector(revokeMessage:)]];
    }
    
    if (message.messageType == NIMMessageTypeAudio) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:Localized(@"转文字", nil) action:@selector(audio2Text:)]];
    }
    
    if ([NTESSessionUtil canMessageBeCanceled:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"取消上传".ntes_localized action:@selector(cancelMessage:)]];
    }
    
    return items;
    
}

- (void)cancelMessage:(id)sender {
    NIMMessage *message = [self messageForMenu];

    [[NIMSDK sharedSDK].chatManager cancelSendingMessage:message];
}

- (void)audio2Text:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) wself = self;
    NTESAudio2TextViewController *vc = [[NTESAudio2TextViewController alloc] initWithMessage:message];
    vc.completeHandler = ^(void){
        [wself uiUpdateMessage:message];
    };
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}

- (void)deleteMsg:(id)sender
{
    NIMMessage *message    = [self messageForMenu];
    BOOL deleteFromServer = [NTESBundleSetting sharedConfig].isDeleteMsgFromServer;
    if (deleteFromServer)
    {
        __weak typeof(self) wSelf = self;
        [[NIMSDK sharedSDK].conversationManager deleteMessageFromServer:message
                                                                    ext:@"扩展字段"
                                                             completion:^(NSError * _Nullable error)
        {
            if (error)
            {
                return;
            }
            
            [wSelf uiDeleteMessage:message];
        }];
    }
    else
    {
        [self uiDeleteMessage:message];
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
    }
    
}

#pragma mark - 转发
- (void)doMergerForwardToSession:(NIMSession *)session {
    __weak typeof(self) weakSelf = self;
    NTESMergeForwardTask *task = [_mergeForwardSession forwardTaskWithMessages:_selectedMessages process:nil completion:^(NSError * _Nonnull error, NIMMessage * _Nonnull message) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"%@：%zd",@"消息合并转发失败".ntes_localized, error.code];
            [weakSelf.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
        } else {
            [weakSelf forwardMessage:message toSession:session];
        }
    }];
    [task resume];
}

- (void)switchUIWithSessionState:(NIMKitSessionState)state {
    switch (state) {
        case NIMKitSessionStateSelect:
        {
            [self setupSelectedNav];
            [self setSessionState:NIMKitSessionStateSelect];
            [self.view addSubview:self.mulSelectedSureBar];
            break;
        }
        case NIMKitSessionStateNormal:
        default:
        {
            [self.mulSelectedSureBar removeFromSuperview];
            [self setSessionState:NIMKitSessionStateNormal];
//            [self setupNormalNav];
//            [self setUpNavItem];
            _selectedMessages = nil;
            break;
        }
    }
}

- (void)cancelSelected:(id)sender {
    [self switchUIWithSessionState:NIMKitSessionStateNormal];
}

- (void)confirmSelected:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self selectForwardSessionCompletion:^(NIMSession *targetSession) {
        //转发批量消息
        [weakSelf doMergerForwardToSession:targetSession];
        //返回正常页面
        [weakSelf switchUIWithSessionState:NIMKitSessionStateNormal];
    }];
}

- (void)confirmDelete:(id)sender
{
    [self showDeleteSureVCWithTitle:@"确定删除？".ntes_localized confirmBlock:^{
        [NIMSDK.sharedSDK.conversationManager deleteRemoteMessages:_selectedMessages
                                                              exts: nil
                                                        completion:^(NSError * _Nullable error) {
            [self.view makeToast:error.localizedDescription ?: @"删除成功".ntes_localized];
            if (!error) {
                [self.interactor resetMessages:^(NSError *error) {
                    [self switchUIWithSessionState:NIMKitSessionStateNormal];
                }];
            }
        }];
    }];
}

- (void)multiSelect:(id)sender {
    [self switchUIWithSessionState:NIMKitSessionStateSelect];
}

- (void)forwardMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    message.setting.teamReceiptEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self selectForwardSessionCompletion:^(NIMSession *targetSession) {
        [weakSelf forwardMessage:message toSession:targetSession];
    }];
}

- (void)selectForwardSessionCompletion:(void (^)(NIMSession *targetSession))completion {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择会话类型".ntes_localized delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized destructiveButtonTitle:nil otherButtonTitles:@"个人".ntes_localized, @"群组".ntes_localized, @"超大群组".ntes_localized, nil];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
                config.needMutiSelected = NO;
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.finshBlock = ^(NSArray *array){
                    NSString *userId = array.firstObject;
                    NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
                    if (completion) {
                        completion(session);
                    }
                };
                [vc show];
            }
                break;
            case 1:{
                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeNomal;
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.finshBlock = ^(NSArray *array){
                    NSString *teamId = array.firstObject;
                    NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                    if (completion) {
                        completion(session);
                    }
                };
                [vc show];
            }
                break;
            case 2: {
                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeSuper;
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.finshBlock = ^(NSArray *array){
                    NSString *teamId = array.firstObject;
                    NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeSuperTeam];
                    if (completion) {
                        completion(session);
                    }
                };
                [vc show];
            }
                break;
            default:
                break;
        }
    }];
}


- (void)revokeMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    
    __weak typeof(self) weakSelf = self;
    NSString *collapseId = message.apnsPayload[@"apns-collapse-id"];
    NSDictionary *payload = @{
        @"apns-collapse-id": collapseId ? : @"",
    };
 
    [[NIMSDK sharedSDK].chatManager revokeMessage:message
                                      apnsContent:@"撤回一条消息"
                                      apnsPayload:payload
                                  shouldBeCounted:![[NTESBundleSetting sharedConfig] isIgnoreRevokeMessageCount]
                                         completion:^(NSError * _Nullable error)
    {
        if (error) {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送时间超过2分钟的消息，不能被撤回".ntes_localized delegate:nil cancelButtonTitle:Localized(@"确定", nil).ntes_localized otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSLog(@"revoke message eror code %zd",error.code);
                [weakSelf.view makeToast:@"消息撤回失败，请重试".ntes_localized duration:2.0 position:CSToastPositionCenter];
            }
        } else {
            NIMMessageModel *model = [weakSelf uiDeleteMessage:message];
            NIMMessage *tip = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:nil]];
            tip.timestamp = model.messageTime;
            [weakSelf uiInsertMessages:@[tip]];
            
            tip.timestamp = message.timestamp;
            // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
            [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
        }
    }];
}

 - (void)forwardMessage:(NIMMessage *)message toSession:(NIMSession *)session
{
    NSString *name;
    if (session.sessionType == NIMSessionTypeP2P) {
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = session;
        name = [[NIMKit sharedKit] infoByUser:session.sessionId option:option].showName;
    }
    else if (session.sessionType == NIMSessionTypeTeam) {
        name = [[NIMKit sharedKit] infoByTeam:session.sessionId option:nil].showName;
    }
    else if (session.sessionType == NIMSessionTypeSuperTeam) {
        name = [[NIMKit sharedKit] infoBySuperTeam:session.sessionId option:nil].showName;
    }
    else {
        NSLog(@"unknown session type %zd", session.sessionType);
    }
    NSString *tip = [NSString stringWithFormat:@"%@ %@ ?", @"确认转发给".ntes_localized, name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认转发".ntes_localized message:tip delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized otherButtonTitles:@"确认".ntes_localized, nil];
    
    __weak typeof(self) weakSelf = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        if(index == 1)
        {
            NSError *error = nil;
            if (message.session) {
                [[NIMSDK sharedSDK].chatManager forwardMessage:message toSession:session error:&error];
            } else {
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
            }
            
            if (error) {
                NSString *msg = [NSString stringWithFormat:@"%@.code:%zd", @"转发失败".ntes_localized, error.code];
                [weakSelf.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
            } else {
                [weakSelf.view makeToast:@"已发送".ntes_localized duration:2.0 position:CSToastPositionCenter];
            }
        }
    }];
}

#pragma mark - 辅助方法enterPersonInfoCard
- (void)sendImageMessagePath:(NSString *)path
{
    [self sendSnapchatMessagePath:path];
}


- (BOOL)checkRTSCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        [self.view makeToast:@"请检查网络".ntes_localized duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (self.session.sessionType == NIMSessionTypeP2P && [currentAccount isEqualToString:self.session.sessionId])
    {
        [self.view makeToast:@"不能和自己通话哦".ntes_localized duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [self.view makeToast:@"无法发起，群人数少于2人".ntes_localized duration:2.0 position:CSToastPositionCenter];
            result = NO;
        }
    }
    if (self.session.sessionType == NIMSessionTypeSuperTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].superTeamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [self.view makeToast:@"无法发起，群人数少于2人".ntes_localized duration:2.0 position:CSToastPositionCenter];
            result = NO;
        }
    }
    return result;
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeRtcCallRecord): @"showCall:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeGIF];
    }
    return _mediaFetcher;
}

- (void)setupNormalNav {
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *enterSuperTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterSuperTeamCard addTarget:self action:@selector(enterSuperTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterSuperTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterSuperTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterSuperTeamCard sizeToFit];
    UIBarButtonItem *enterSuperTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterSuperTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(enterPersonInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_normal"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_pressed"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];

    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        self.navigationItem.rightBarButtonItems  = @[enterTeamCardItem,historyButtonItem];
    }
    else if (self.session.sessionType == NIMSessionTypeSuperTeam)
    {
        self.navigationItem.rightBarButtonItems  = @[enterSuperTeamCardItem,historyButtonItem];
    }
    else if(self.session.sessionType == NIMSessionTypeP2P)
    {
        if ([self.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
        {
            self.navigationItem.rightBarButtonItems = @[historyButtonItem];
        }
        else
        {
            self.navigationItem.rightBarButtonItems = @[enterUInfoItem,historyButtonItem];
        }
    }
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    [self.mulSelectCancelBtn removeFromSuperview];
}

- (void)setupSelectedNav {
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:self.mulSelectCancelBtn];
}

- (BOOL)shouldAutorotate{
    return !self.currentSingleSnapView;
}

- (NTESMulSelectFunctionBar *)mulSelectedSureBar {
    if (!_mulSelectedSureBar) {
        _mulSelectedSureBar = [[NTESMulSelectFunctionBar alloc] initWithFrame:self.sessionInputView.frame];
        [_mulSelectedSureBar.sureBtn addTarget:self
                                        action:@selector(confirmSelected:)
                              forControlEvents:UIControlEventTouchUpInside];
        [_mulSelectedSureBar.deleteButton addTarget:self
                                             action:@selector(confirmDelete:)
                                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _mulSelectedSureBar;
}

- (UIButton *)mulSelectCancelBtn {
    if (!_mulSelectCancelBtn) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:Localized(@"取消", nil).ntes_localized forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 48, 40);
        UIEdgeInsets titleInsets = cancelBtn.titleEdgeInsets;
        [cancelBtn setTitleEdgeInsets:titleInsets];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _mulSelectCancelBtn = cancelBtn;
    }
    return _mulSelectCancelBtn;
}


- (UISearchController *)searchController
{
    if (!_searchController)
    {
        NTESMessageRetrieveResultVC * resultVC = [[NTESMessageRetrieveResultVC alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.obscuresBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.delegate = self;
        resultVC.searchBar = _searchController.searchBar;

    }
    return _searchController;
}

- (BOOL)shouldShowMenuByMessage:(NIMMessage *)message
{
    id<NIMMessageObject> messageObject = message.messageObject;
    
    
    if (message.session.sessionType == NIMSessionTypeChatroom ||
        message.messageType == NIMMessageTypeTip ||
        message.messageType == NIMMessageTypeNotification ||
        [self cancelMenuByMessageObject:messageObject])
    {
        return NO;
    }
    return YES;
}

- (BOOL)cancelMenuByMessageObject:(id<NIMMessageObject>) object
{
    if ([object isKindOfClass:[NIMCustomObject class]])
    {
        NIMCustomObject *custom = object;
        id<NIMCustomAttachment>  attachment = custom.attachment;
        if ([attachment isKindOfClass:[NTESWhiteboardAttachment class]])
        {
            return YES;
        }
    }
    return NO;
}


@end
