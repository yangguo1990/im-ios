//
//
//#import "ML_SessionListViewController.h"
//#import "ML_SessionViewController.h"
//#import "NTESSessionPeekViewController.h"
//#import "UIView+NTES.h"
//#import "NTESBundleSetting.h"
//#import "NTESListHeader.h"
//#import "NTESClientsTableViewController.h"
//#import "NTESSessionUtil.h"
//#import "NTESPersonalCardViewController.h"
//#import "NTESMessageUtil.h"
//#import "ML_TonghuaViewCell.h"
//#import "NTESSessionSearchViewController.h"
//#import "NSString+NTES.h"
//#import <Toast/UIView+Toast.h>
//#import "WRCustomNavigationBar.h"
//#import "UIImage+ML.h"
//#import "ML_JubaoVC.h"
//#import "ML_SessionHeadCell.h"
//#import "ML_GuanfangMsgVC.h"
//#import "ML_GiftAttachment.h"
//#import "UIButton+ML.h"
//#import <UserNotifications/UserNotifications.h>
//#import "NIMSessionListCell.h"
//#import "ML_TonghuaListVC.h"
//#import "ML_HaoyouListVC.h"
//#import "UIAlertView+NTESBlock.h"
//
//#define SessionListTitle Localized(@"消息", nil).ntes_localized
//
//@interface ML_SessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate,NIMEventSubscribeManagerDelegate,UIViewControllerPreviewingDelegate,NIMChatExtendManagerDelegate, NIMConversationManagerDelegate>
//@property (nonatomic,strong) ML_TonghuaListVC *tongVC;
//@property (nonatomic,strong) ML_HaoyouListVC *haoyouVC;
//@property (nonatomic,strong) UIButton *kongImgView;
//@property (nonatomic,strong)UIButton *chaBtn;
//@property (nonatomic,strong) NTESListHeader *header;
//@property (nonatomic,strong)UIButton *navBtn;
//@property (nonatomic,strong)UIButton *msgBtn;
//@property (nonatomic,strong)UIImageView *navImg0;
//@property (nonatomic,strong)UIImageView *navImg1;
//@property (nonatomic,assign) BOOL supportsForceTouch;
//
//@property (nonatomic,strong) NSMutableDictionary *previews;
////@property (nonatomic,strong) NSDictionary *officialInfo;
//@property (nonatomic,strong) NSMutableDictionary<NIMSession *,NIMStickTopSessionInfo *> *stickTopInfos;
//
//@property (nonatomic,strong) NSTimer *timer;
//@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;
//@property (nonatomic,strong) NSMutableSet * fetchInfoUsersSet;
//@end
//
//@implementation ML_SessionListViewController
//
//- (void)dealloc{
//    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
//    [[NIMSDK sharedSDK].chatExtendManager removeDelegate:self];
//    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //关闭定时器
//    [self.timer setFireDate:[NSDate distantFuture]];
//}
//
//- (void)viewDidLoad{
//    [super viewDidLoad];
//
//    _previews = [[NSMutableDictionary alloc] init];
//    self.stickTopInfos = NSMutableDictionary.dictionary;
//    self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
//    _fetchInfoUsersSet = [NSMutableSet set];
//    self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
//
//
//    [[NIMSDK sharedSDK].loginManager addDelegate:self];
//    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
//    [[NIMSDK sharedSDK].chatExtendManager addDelegate:self];
//    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
//
//    self.header = [[NTESListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
//    self.header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.header.delegate = self;
//    [self.view addSubview:self.header];
////
//
//    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
//    self.navigationItem.titleView  = [self titleView:userID];
//    self.definesPresentationContext = YES;
//
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    [self setupNavBar];
//    [self setUpNavItem];
//
//    [self ML_AddNotification];
//
//    if ([ML_AppUtil isCensor]) {
//
//        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//        [[NIMSDKConfig sharedConfig] setShouldSyncStickTopSessionInfos:YES];
//
//        if (userData.officialInfo) {
//            NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//
//            NIMAddEmptyRecentSessionBySessionOption * op = [NIMAddEmptyRecentSessionBySessionOption new];
//            op.withLastMsg = YES;
//
//            NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//            NIMSession * session0 = [NIMSession session:[NSString stringWithFormat:@"%@", dic0[@"id"]?:@""] type:NIMSessionTypeP2P];
//            [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session0 option:op];
//
//
//            BOOL mag = (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//
//            //        NSDictionary *newestMsgDic = dic1[@"newestMsg"];
//            if (!mag) {
//
//                NIMSession * session1 = [NIMSession session:dic1[@"name"]?:@"" type:NIMSessionTypeP2P];
//                [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session1 option:op];
//
//            }
//
//            extern NSString *NTESCustomNotificationCountChanged;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
//
//        } else {
//
//            [self getMsgListData];
//        }
//
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(countDownHandler) userInfo:nil repeats:YES];
//    }
//
//
//
////    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 45)];
////    self.tableView.tableHeaderView = hView;
//
//    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth / 2, 45)];
//    navBtn.tag = 0;
//    navBtn.backgroundColor = self.view.backgroundColor;
//    [navBtn setTitle:Localized(@"好友列表", nil) forState:UIControlStateNormal];
//    [navBtn addTarget:self action:@selector(btntongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    [navBtn setTitleColor:kZhuColor forState:UIControlStateSelected];
//    [self.view addSubview:navBtn];
//    navBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    navBtn.selected = YES;
//    if (!_msgBtn) {
//        self.msgBtn = navBtn;
//    }
//
//    UIButton *navBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2, ML_NavViewHeight, navBtn.width, 45)];
//    navBtn2.tag = 1;
//    navBtn2.backgroundColor = navBtn.backgroundColor;
//    navBtn2.titleLabel.font = kGetFont(16);
//    [navBtn2 setTitle:Localized(@"历史消息", nil) forState:UIControlStateNormal];
//    [navBtn2 addTarget:self action:@selector(btntongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navBtn2 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    [navBtn2 setTitleColor:kZhuColor forState:UIControlStateSelected];
//    [self.view addSubview:navBtn2];
//
//
//
//
//    ML_TonghuaListVC *vc = [ML_TonghuaListVC new];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    vc.view.hidden = YES;
//    self.tongVC = vc;
//
//
//    ML_HaoyouListVC *haoVc = [ML_HaoyouListVC new];
//    [self addChildViewController:haoVc];
//    [self.view addSubview:haoVc.view];
////    vc.view.hidden = YES;
//    self.haoyouVC = haoVc;
//
//}
//
//- (void)ML_AddNotification{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaTong) name:@"shuaTong" object:nil];
//}
//
//- (void)shuaTong
//{
//    [self refresh];
//}
//
//
//- (void)setupNavBar
//{
//    self.ML_titleLabel.textColor = kZhuColor;
//    self.ML_navView.backgroundColor = [UIColor clearColor];
//
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
//    lineView.image = kGetImage(@"home_icon_tags");
//    lineView.center = CGPointMake(self.ML_titleLabel.width / 2, self.ML_titleLabel.height - 12);
//    [self.ML_titleLabel addSubview:lineView];
//
////    [self.view addSubview:self.customNavBar];
////    self.customNavBar.backgroundColor = [UIColor clearColor];
//    // 设置自定义导航栏背景图片
////    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"bg"];
//    // 设置自定义导航栏标题颜色
////    self.customNavBar.titleLabelColor = [UIColor blackColor];
////    self.customNavBar.backgroundColor = [UIColor whiteColor];
//
//}
//
////- (WRCustomNavigationBar *)customNavBar
////{
////    if (_customNavBar == nil) {
////        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
////        [_customNavBar wr_setBottomLineHidden:YES];
////
////    }
////    return _customNavBar;
////}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self loadStickTopSessions];
////    [self.navigationController setNavigationBarHidden:YES];
//
//
//    [self.timer setFireDate:[NSDate distantPast]];
//
//
//    for (UIView *view in self.tabBarController.view.subviews) {
//        if (view.tag == 1001) {
//            [view removeFromSuperview];
//            break;
//        }
//    }
//
//}
//
//
//- (void)countDownHandler
//{
//    [self getMsgListData];
//
//}
//
//- (void)getMsgListData
//{
//    // 获取官方推送消息 （提醒内容接口）
//    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/official"/*@"push/getNewestPushMessage"*/];
//    api.needShowHUD = NO;
//    kSelf;
//    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
//
//        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//        userData.officialInfo = response.data;
//        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
//
//        NSDictionary *dic1 = response.data[@"officialMsgInfo"];
//        NSDictionary *messageDic = dic1[@"newestMsg"][@"message"];
//        if ([messageDic[@"msgType"] intValue] == 999 && [ML_AppUtil isCensor]) {
//            ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
//            tanV.dic = @{@"type" : @(ML_TanchuangViewType_TishiImg), @"imgStr" : @"zhu_ti_bg", @"data" : messageDic[@"id"]};
//        }
//
//        NIMAddEmptyRecentSessionBySessionOption * op = [NIMAddEmptyRecentSessionBySessionOption new];
//        op.withLastMsg = YES;
//
//        BOOL mag = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]] boolValue];
//
//
//
//        NSDictionary *dic0 = response.data[@"officialServInfo"];
//        NIMSession * session0 = [NIMSession session:[NSString stringWithFormat:@"%@", dic0[@"id"]?:@""] type:NIMSessionTypeP2P];
//         [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session0 option:op];
//
//
//        NSDictionary *newestMsgDic = dic1[@"newestMsg"];
//        if (!mag) {
//
//             NIMSession * session1 = [NIMSession session:dic1[@"name"]?:@"" type:NIMSessionTypeP2P];
//             [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session1 option:op];
//
//        }
//
//
//
//        if ([newestMsgDic[@"notRead"] boolValue]) {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//
//            extern NSString *NTESCustomNotificationCountChanged;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
//
//            [self refresh];
//        }
//
//    } error:^(MLNetworkResponse *response) {
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}
//
//- (void)navBtnClick:(UIButton *)btn
//{
//
//    self.navBtn.titleLabel.font = kGetFont(16);
//
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//
//    self.navBtn = btn;
//
//    if (btn.tag == 0) {
//        self.haoyouVC.view.hidden = self.msgBtn.tag;
//
//        self.ML_rightBtn.hidden = !self.msgBtn.tag;
//        self.self.tongVC.view.hidden = YES;
//        self.navImg0.hidden = NO;
//        self.navImg1.hidden = YES;
//
//    } else {
//        self.haoyouVC.view.hidden = YES;
//        self.ML_rightBtn.hidden = YES;
//        self.self.tongVC.view.hidden = NO;
//        self.navImg0.hidden = YES;
//        self.navImg1.hidden = NO;
//
////        self.tableView.tableHeaderView = nil;
////        [self.tableView reloadData]
//    }
//
//}
//
//- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint point = [gestureRecognizer locationInView:self.tableView];
//        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
//        if (indexPath) {
//            // 处理长按事件的代码
//
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"置顶当前用户？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
//            [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
//                switch (alertIndex) {
//                    case 1:
//                    {
//                        NIMSession *session = [NIMSession session:@"630292" type:NIMSessionTypeP2P];
//
//                        NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:session];
//                        [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
//
//                            if (error) {
//                               // handle error
//                               NSLog(@"asdf--afd-%@", error);
//                               return;
//                            }
//
//                             [self loadStickTopSessions];
////                            [self.tableView reloadData];
//                        }];
//
//                        NIMLoadRecentSessionsOptions *options = [[NIMLoadRecentSessionsOptions alloc] init];
//                        options.sortByStickTopInfos = YES;
//                        [NIMSDK.sharedSDK.chatExtendManager loadRecentSessionsWithOptions:options completion:^(NSError * _Nullable error, NSArray<NIMRecentSession *> * _Nullable recentSessions) {
//                                if (error) {
//                                    // handle error
//                                return;
//                                }
//                              // Do something with {recentSessions}
//                        }];
//
//
//
//                        break;
//                    }
//                    default:
//                        break;
//                }
//            }];
//
//            NSLog(@"长按");
//        }
//    }
//}
//
//
//- (void)setUpNavItem{
//
//
//
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPressGesture.minimumPressDuration = 0.5; // 设置长按时间阈值
//    [self.tableView addGestureRecognizer:longPressGesture];
//
//
////    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, _customNavBar.height - 44, ML_ScreenWidth - 200, 44)];
////    _customNavBar.titleLabelColor = [UIColor blackColor];
//////    titleLabel.text = SessionListTitle;
////    _customNavBar.titleLabelColorTextAlignment = NSTextAlignmentCenter;
////    _customNavBar.titleLabelFont = [UIFont boldSystemFontOfSize:17];
////    titleLabel.textAlignment = NSTextAlignmentCenter;
////    [_customNavBar addSubview: titleLabel];
////    self.ML_titleLabel.text = Localized(@"消息", nil);
//    self.ML_titleLabel.hidden = YES;
//    self.tableView.hidden = YES;
//    self.ML_rightBtn.hidden = YES;
//
//
//    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.ML_navView.height - 44, 60, 44)];
//    navBtn.tag = 0;
//    navBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [navBtn setTitle:Localized(@"消息", nil) forState:UIControlStateNormal];
//    [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    [self.ML_navView addSubview:navBtn];
//    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
//    imgV.image = kGetImage(@"home_icon_tags");
//    imgV.center = CGPointMake(navBtn.width / 2, navBtn.height-10);
//    [navBtn addSubview:imgV];
//    self.navBtn = navBtn;
//    self.navImg0 = imgV;
//
//    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(navBtn.frame) + 10, self.ML_navView.height - 44, 100, 44)];
//    msgBtn.tag = 1;
//    msgBtn.titleLabel.font = kGetFont(16);
//    [msgBtn setTitle:Localized(@"通话记录", nil) forState:UIControlStateNormal];
//    [msgBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [msgBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    [self.ML_navView addSubview:msgBtn];
//    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
//    imgV2.image = kGetImage(@"home_icon_tags");
//    imgV2.center = CGPointMake(msgBtn.width / 2, msgBtn.height-10);
//    [msgBtn addSubview:imgV2];
//    imgV2.hidden = YES;
//    self.navImg1 = imgV2;
//
//    [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_sessionlist_more_normal")];
//}
//
//- (void)refresh{
//    [super refresh];
//    self.kongImgView.hidden = self.recentSessions.count;
//}
//
//- (NSMutableArray *)setupAlertActions {
//    UIAlertAction *markAllMessagesReadAction = [UIAlertAction actionWithTitle:@"标记所有消息为已读".ntes_localized
//                                                                        style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * _Nonnull action) {
//          [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
//    }];
//
//    UIAlertAction *cleanAllMessagesAction = [UIAlertAction actionWithTitle:@"清理所有消息".ntes_localized
//                                                                     style:UIAlertActionStyleDefault
//                                                                   handler:^(UIAlertAction * _Nonnull action) {
//           BOOL removeRecentSessions = [NTESBundleSetting sharedConfig].removeSessionWhenDeleteMessages;
//           BOOL removeTables = [NTESBundleSetting sharedConfig].dropTableWhenDeleteMessages;
//
//           NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
//           option.removeSession = removeRecentSessions;
//           option.removeTable = removeTables;
//
//           [[NIMSDK sharedSDK].conversationManager deleteAllMessages:option];
//    }];
//
//
//    UIAlertAction *allServerSessions = [UIAlertAction actionWithTitle:@"查看云端会话".ntes_localized
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * _Nonnull action) {
////        NTESSessionServiceListVC * vc = [[NTESSessionServiceListVC alloc] init];
////        [self.navigationController pushViewController:vc animated:YES];
//    }];
//
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil).ntes_localized
//                                                     style:UIAlertActionStyleCancel
//                                                   handler:nil];
//    return @[markAllMessagesReadAction, cleanAllMessagesAction, allServerSessions, cancel].mutableCopy;
//}
//
//- (void)ML_rightItemClicked
//{
//
//    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
//    tanV.dic = @{@"type" : @(ML_TanchuangViewType_MsgListVCMore)};
//    tanV.ML_TanchuangClickBlock = ^(NSInteger tag) {
//        if (tag == 1) {
//
//            NSArray * tempArray = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
////            NSMutableArray * shouldDeleteSessons = [NSMutableArray array]; // 过滤不用删除的
////            for(NIMRecentSession * recentSession in tempArray){
////                if (![recentSession.delete_disabled isEqualToString:@"1"]) {
////                    [shouldDeleteSessons addObject:recentSession];
////                }
////            }
//
//            for(NIMRecentSession * recentSession in tempArray){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
//
//                    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//                    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//                    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//
//                    if (![recentSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]) {
//
//                        [manager markAllMessagesReadInSession:recentSession.session];
//                        NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
//                        options.removeOtherClients = YES;
//                        kSelf;
//                        [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:recentSession.session options:options completion:^(NSError * _Nullable error) {
//                            if (error) {
//                                [weakself.view makeToast:[NSString stringWithFormat: @"删除失败:%@", error.localizedDescription]];
//                                return;
//                            }
//                        }];
//
//                        [manager deleteRecentSession:recentSession];
//
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//                        extern NSString *NTESCustomNotificationCountChanged;
//                        [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
//
//                    }
//                });
//            }
//
//
//        } else if (tag == 2) {
//            [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
//
//            UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//
//                NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//                NSDictionary *newestMsgDic = dic1[@"newestMsg"];
//
//            extern NSString *NTESCustomNotificationCountChanged;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:newestMsgDic[@"notRead"]];
////            self.isBadgeViewHi = YES;
//            [self refresh];
//
//            [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
//
//
//            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"push/getPushMessage"];
//            kSelf;
//            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
//
//                NSMutableArray *listArr = [NSMutableArray arrayWithArray:response.data[@"messages"]];
//
//                [[NSUserDefaults standardUserDefaults] setObject:listArr forKey:[NSString stringWithFormat:@"getPushMessage_%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//
//            } error:^(MLNetworkResponse *response) {
//            } failure:^(NSError *error) {
//
//            }];
//
//        }
//    };
////
////    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
////                                                                message:nil
////                                                         preferredStyle:UIAlertControllerStyleActionSheet];
////
////    NSArray *actions = [self setupAlertActions];
////    for (UIAlertAction *action in actions) {
////        [vc addAction:action];
////    }
////    [self presentViewController:vc animated:YES completion:nil];
//}
//
//- (void)searchAction:(id)sender {
//    NTESSessionSearchViewController *searchVC = [[NTESSessionSearchViewController alloc] init];
//    searchVC.recentSessions = self.recentSessions;
//    [self.navigationController pushViewController:searchVC animated:YES];
//}
//
//- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
//
//    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
////    if ([recent.session.sessionId isEqualToString:dic1[@"name"]]) {
//    if ([recent.session.sessionId caseInsensitiveCompare:dic1[@"name"]]==NSOrderedSame) {
//        self.isBadgeViewHi = YES;
//        ML_GuanfangMsgVC *vc = [ML_GuanfangMsgVC new];
//        vc.RefreshContenBlock = ^(BOOL isHi) {
//            self.isBadgeViewHi = isHi;
//
//            NSDictionary *newestMsgDic = dic1[@"newestMsg"];
//
//
//            extern NSString *NTESCustomNotificationCountChanged;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:@([newestMsgDic[@"notRead"] integerValue])];
//
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        ML_SessionViewController *vc = [[ML_SessionViewController alloc] initWithSession:recent.session];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
//- (void)onSelectedAvatar:(NIMRecentSession *)recent
//             atIndexPath:(NSIndexPath *)indexPath{
//    if (recent.session.sessionType == NIMSessionTypeP2P) {
////        UIViewController *vc;
////        vc = [[NTESPersonalCardViewController alloc] initWithUserId:recent.session.sessionId];
////        [self.navigationController pushViewController:vc animated:YES];
//        [self gotoInfoVC:recent.session.sessionId];
//    }
//}
//
//- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
//{
//    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
//    [manager deleteRecentSession:recent];
//}
//
//- (void)onTopRecentAtIndexPath:(NIMRecentSession *)recent
//                   atIndexPath:(NSIndexPath *)indexPath
//                         isTop:(BOOL)isTop
//{
//    if (isTop)
//    {
//        __weak typeof(self) wself = self;
//        [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:self.stickTopInfos[recent.session] completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
//            __weak typeof(self) sself = wself;
//            if (!sself) return;
//            if (error) {
//                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//                return;
//            }
//            self.stickTopInfos[recent.session] = nil;
//            [self refresh];
//        }];
//    } else {
//        __weak typeof(self) wself = self;
//        NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:recent.session];
//        [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
//            __weak typeof(self) sself = wself;
//            if (!sself) return;
//            if (error) {
//                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//                return;
//            }
//            self.stickTopInfos[newInfo.session] = newInfo;
//            [self refresh];
//        }];
//    }
//}
//
//
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    [self refreshSubview];
//}
//
//
//- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
//    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
//        return @"我的电脑".ntes_localized;
//    }
//    return [super nameForRecentSession:recent];
//}
//
//- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions
//{
//    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//
//    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//
//    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//
//    // 保证官方消息在第二
//    NSMutableArray * theRecentSessionArray = [NSMutableArray arrayWithArray:self.recentSessions];
//    NIMRecentSession * theRecentSession = nil;
//    for(NIMRecentSession * tSession in theRecentSessionArray){
//        if([tSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic1[@"name"]]]){
//            theRecentSession = tSession;
//            [theRecentSessionArray removeObject:tSession];
//
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//
//            UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//
//            if (userData.officialInfo) {
//                NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//                NSDictionary *newestMsgDic = dic1[@"newestMsg"];
//                if ([newestMsgDic[@"notRead"] boolValue]) {
//                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//                }
//            }
//
//
//
//            break;
//        }
//    }
//    if (theRecentSession) {
//
//        [theRecentSessionArray insertObject:theRecentSession atIndex:0];
//    }
//    // 保证官方客服在第1
//    theRecentSession = nil;
//    for(NIMRecentSession * tSession in theRecentSessionArray){
//        if([tSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]){
//            theRecentSession = tSession;
//            [theRecentSessionArray removeObject:tSession];
//            break;
//        }
//    }
//    if (theRecentSession) {
//
//        [theRecentSessionArray insertObject:theRecentSession atIndex:0];
//    }
//
//
//    self.recentSessions = theRecentSessionArray;
//    return self.recentSessions;
////    [NIMSDK.sharedSDK.chatExtendManager sortRecentSessions:recentSessions withStickTopInfos:self.stickTopInfos];
////    return recentSessions;
//}
//
//#pragma mark - SessionListHeaderDelegate
//
//- (void)didSelectRowType:(NTESListHeaderType)type{
//    //多人登录
//    switch (type) {
//        case ListHeaderTypeLoginClients:{
//            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] initWithNibName:nil bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//
//#pragma mark - NIMLoginManagerDelegate
//- (void)onLogin:(NIMLoginStep)step{
//    [super onLogin:step];
//    switch (step) {
//        case NIMLoginStepLinkFailed:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)".ntes_localized];
//            break;
//        case NIMLoginStepLinking:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)".ntes_localized];
//            break;
//        case NIMLoginStepLinkOK:
//        case NIMLoginStepSyncOK:
//            self.titleLabel.text = SessionListTitle;
//            break;
//        case NIMLoginStepSyncing:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)".ntes_localized];
//            break;
//        default:
//            break;
//    }
//    [self.titleLabel sizeToFit];
//    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
//    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
//    [self refreshSubview];
//}
//
//- (void)onMultiLoginClientsChanged
//{
//    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
//    [self refreshSubview];
//}
//
//- (void)onTeamUsersSyncFinished:(BOOL)success
//{
//}
//
//- (void)kaiClick:(UIButton *)btn
//{
//    if (btn.tag == 1) {
//
//        self.chaBtn.tag = 2;
//        [self.chaBtn.superview removeFromSuperview];
//        [self.tableView reloadData];
//
//    } else
//    if (btn.tag == 0){
//        kSelf;
//            //不能定位提示
//            UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:Localized(@"允许\"通知\"提示",nil) message:Localized(@"请在设置中打开通知",nil) preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *Enter = [UIAlertAction actionWithTitle:Localized(@"打开通知",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSURL *SettingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                [[UIApplication sharedApplication] openURL:SettingsUrl options:nil completionHandler:^(BOOL success) {
//
//
////                    weakself.chaBtn.tag = 2;
////                    [weakself.chaBtn.superview removeFromSuperview];
////                    [weakself.tableView reloadData];
//
//                }];
//            }];
//            UIAlertAction *Cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [AlertVC addAction:Enter];
//            [AlertVC addAction:Cancel];
//            [self presentViewController:AlertVC animated:YES completion:nil];
//    }
//
//}
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    if (self.chaBtn.tag == 2) {
//        return self.navBtn.tag?0:45;
//    }
//
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NotTongQuan"] boolValue]) {
//        // 没权限
//        CGFloat H =  (ML_ScreenWidth - 32) * 74 / 343;
//        return H+(self.navBtn.tag?0:45);
//    } else {
//        return self.navBtn.tag?0:45;
//    }
//}
//
//- (void)btntongBtnClick:(UIButton *)btn
//{
//    self.msgBtn.selected = NO;
//    self.msgBtn.titleLabel.font = kGetFont(16);
//    btn.selected = YES;
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    self.msgBtn = btn;
//
//    self.ML_rightBtn.hidden = !btn.tag;
//    self.haoyouVC.view.hidden = btn.tag;
//
////    if (btn.tag == 0) {
////
////        self.haoyouVC.view.hidden = NO;
////
////    } else {
////
////        self.haoyouVC.view.hidden = YES;
////
////    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat H = (ML_ScreenWidth - 32) * 74 / 343;
//    UIButton *btntong = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, H)];
////        [btntong setBackgroundImage:[UIImage imageNamed:@"notification_background"] forState:UIControlStateNormal];
////    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth / 2, 45)];
////    navBtn.tag = 0;
////    [navBtn setTitle:Localized(@"好友列表", nil) forState:UIControlStateNormal];
////    [navBtn addTarget:self action:@selector(btntongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    [navBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
////    [navBtn setTitleColor:kZhuColor forState:UIControlStateSelected];
////    [btntong addSubview:navBtn];
////
////    UIButton *navBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2, 0, navBtn.width, 45)];
////    navBtn2.tag = 1;
////    [navBtn2 setTitle:Localized(@"历史消息", nil) forState:UIControlStateNormal];
////    [navBtn2 addTarget:self action:@selector(btntongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    [navBtn2 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
////    [navBtn2 setTitleColor:kZhuColor forState:UIControlStateSelected];
////    [btntong addSubview:navBtn2];
////
////    if (!self.msgBtn) {
////        navBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
////        navBtn.selected = YES;
////        navBtn2.titleLabel.font = kGetFont(16);
////        navBtn2.selected = NO;
////        self.msgBtn = navBtn;
////    } else {
////        if(self.msgBtn.tag == navBtn.tag) {
////            navBtn.selected = YES;
////            navBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
////            navBtn2.titleLabel.font = kGetFont(16);
////            navBtn2.selected = NO;
////        } else {
////
////            navBtn2.selected = YES;
////            navBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:20];
////            navBtn.titleLabel.font = kGetFont(16);
////            navBtn.selected = NO;
////        }
////    }
////
//
//    if (self.chaBtn.tag == 2) {
//
//        btntong.frame = CGRectMake(0, 0, ML_ScreenWidth, (self.navBtn.tag?0:45));
////        btntong.backgroundColor = [UIColor redColor];
//
//
//        return btntong;
//    }
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NotTongQuan"] boolValue]) {
//
//        UIImageView *bbImg = [[UIImageView alloc] initWithImage:kGetImage(@"notification_background")];
//        bbImg.size = bbImg.image.size;
//        bbImg.center = CGPointMake(btntong.width / 2, btntong.height / 2 + 45);
//        [btntong addSubview:bbImg];
//
//
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(84,17 + 45, 170,20);
////        label.numberOfLines = 0;
//        [btntong addSubview:label];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:Localized(@"打开通知，及时接受消息", nil) attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//
//        label.attributedText = string;
//        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//        label.textAlignment = NSTextAlignmentLeft;
//        label.alpha = 1.0;
//
//        UILabel *label2 = [[UILabel alloc] init];
//        label2.frame = CGRectMake(84, 40 + 45, 216, 17);
//        label2.numberOfLines = 0;
//        [btntong addSubview:label2];
//
//        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:Localized(@"交友成功10倍", nil) attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
//        label2.attributedText = string2;
//        label2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        label2.textAlignment = NSTextAlignmentLeft;
//        label2.alpha = 1.0;
//
//
//        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 80 - 28, H / 2 - 16 + 45, 80, 32)];
//        btn1.tag = 0;
//        btn1.titleLabel.font = [UIFont systemFontOfSize:16];
//        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn1.layer.cornerRadius = 16;
//        btn1.backgroundColor = kZhuColor;
//        [btn1 addTarget:self action:@selector(kaiClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn1 setTitle:Localized(@"去开启", nil) forState:UIControlStateNormal];
//        [btntong addSubview:btn1];
//
//
//        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 22 - 16, 0 + 45, 22, 22)];
//        btn2.tag = 1;
//        [btn2 addTarget:self action:@selector(kaiClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"Slice 5"] forState:UIControlStateNormal];
//        [btntong addSubview:btn2];
//        self.chaBtn = btn2;
//
//        return btntong;
//    } else {
//
//        btntong.frame = CGRectMake(0, 0, ML_ScreenWidth, (self.navBtn.tag?0:45));
////        btntong.backgroundColor = [UIColor redColor];
//
//
//        return btntong;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.supportsForceTouch) {
//        id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:cell];
//        [self.previews setObject:preview forKey:@(indexPath.row)];
//    }
//
//    NIMRecentSession *recent = self.recentSessions[indexPath.row];
//    NSString * userId = recent.session.sessionId;
//    if(userId && ![_fetchInfoUsersSet containsObject:userId]){
//        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId]
//                                            completion:^(NSArray *users, NSError *error) {
//                                                if (!error) {
//                                                    //通知会导致死循环-reload->fetch->reload,所以上层必须控制
//                                                    [[NIMKit sharedKit] notfiyUserInfoChanged:@[userId]];
//                                                }
//                                            }];
//        [_fetchInfoUsersSet addObject:userId];
//    }
//
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (self.supportsForceTouch) {
//        id<UIViewControllerPreviewing> preview = [self.previews objectForKey:@(indexPath.row)];
//        [self unregisterForPreviewingWithContext:preview];
//        [self.previews removeObjectForKey:@(indexPath.row)];
//    }
//
//}
//
//
//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
//    UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
//        return nav;
//    }
//    return nil;
//}
//
//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
//    UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        ML_SessionViewController *vc = [[ML_SessionViewController alloc] initWithSession:recent.session];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 偶现侧滑数组越界，但并没有发现并发问题，暂且防护
//    return indexPath.row < self.recentSessions.count;
////    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
////    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
////    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
////    if ([recentSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]) {
////        return NO;
////    }
////    return YES;
//}
//
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    __weak typeof(self) weakSelf = self;
//    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除".ntes_localized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
//        [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
//        [tableView setEditing:NO animated:YES];
//
//        // 删除置顶
//        NIMStickTopSessionInfo *stickTopInfo = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:recentSession.session];
//        if (stickTopInfo) {
//            [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:stickTopInfo completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
//                __strong typeof(self) sself = weakSelf;
//                if (!sself) return;
//                if (!error) {
//                    self.stickTopInfos[recentSession.session] = nil;
//                }
//            }];
//        }
//    }];
//
//
//    NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
//    BOOL isTop = self.stickTopInfos[recentSession.session] != nil;
//    UITableViewRowAction *top = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:isTop?@"取消置顶".ntes_localized:@"置顶".ntes_localized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [weakSelf onTopRecentAtIndexPath:recentSession atIndexPath:indexPath isTop:isTop];
//        [tableView setEditing:NO animated:YES];
//    }];
//
//    return @[delete,top];
//}
//
//#pragma mark - NIMEventSubscribeManagerDelegate
//
//- (void)onRecvSubscribeEvents:(NSArray *)events
//{
//    NSMutableSet *ids = [[NSMutableSet alloc] init];
//    for (NIMSubscribeEvent *event in events) {
//        [ids addObject:event.from];
//    }
//
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        if (recent.session.sessionType == NIMSessionTypeP2P) {
//            NSString *from = recent.session.sessionId;
//            if ([ids containsObject:from]) {
//                [indexPaths addObject:indexPath];
//            }
//        }
//    }
//
//    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//}
//
//- (void)onNotifyAddStickTopSession:(NIMStickTopSessionInfo *)newInfo
//{
//    self.stickTopInfos[newInfo.session] = newInfo;
//    [self refresh];
//}
//
//- (void)onNotifyRemoveStickTopSession:(NIMStickTopSessionInfo *)removedInfo
//{
//    self.stickTopInfos[removedInfo.session] = nil;
//    [self refresh];
//}
//
//- (void)onNotifySyncStickTopSessions:(NIMSyncStickTopSessionResponse *)response
//{
//    if (response.hasChange) {
//        [self.stickTopInfos removeAllObjects];
//        [response.allInfos enumerateObjectsUsingBlock:^(NIMStickTopSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            self.stickTopInfos[obj.session] = obj;
//        }];
//        [self refresh];
//    }
//}
//
//#pragma mark - NIMConversationManagerDelegate
//- (void)onMarkMessageReadCompleteInSession:(NIMSession *)session error:(NSError *)error {
//    if (error) {
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        NSString *msg = [NSString stringWithFormat:@"session %@ type %@ mark fail.code:%@",
//                         session.sessionId, @(session.sessionType), @(error.code)];
//        [keyWindow makeToast:msg duration:2 position:CSToastPositionCenter];
//    }
//}
//
//#pragma mark - Private
//
//- (void)refreshSubview{
//    [self.titleLabel sizeToFit];
//    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
//    if (@available(iOS 11.0, *))
//    {
////        NSLog(@"sdfsa====%f", ML_NavViewHeight);
//        self.header.top = self.view.safeAreaInsets.top;
//        self.tableView.top = self.header.bottom + 44;
//        CGFloat offset = self.view.safeAreaInsets.bottom;
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
//    }
//    else
//    {
//        self.tableView.top = self.header.height;
//        self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
//    }
//    self.tableView.height = self.view.height - self.tableView.top - SSL_TabbarHeight;
//
//    self.kongImgView.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
//}
//
//- (UIView*)titleView:(NSString*)userID{
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.titleLabel.text =  SessionListTitle;
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
//    [self.titleLabel sizeToFit];
//    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
//    subLabel.textColor = [UIColor grayColor];
//    subLabel.font = [UIFont systemFontOfSize:12.f];
//    subLabel.text = userID;
//    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [subLabel sizeToFit];
//
//    UIView *titleView = [[UIView alloc] init];
//    titleView.width  = subLabel.width;
//    titleView.height = self.titleLabel.height + subLabel.height;
//
//    subLabel.bottom = titleView.height;
//    [titleView addSubview:self.titleLabel];
//    [titleView addSubview:subLabel];
//    return titleView;
//}
//
//
//- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
//    NSAttributedString *content;
//    if (recent.lastMessage.messageType == NIMMessageTypeCustom)
//    {
//        NIMCustomObject *object = recent.lastMessage.messageObject;
//        NSString *text = [NTESMessageUtil messageContent:recent.lastMessage];
//        if (recent.session.sessionType != NIMSessionTypeP2P)
//        {
//            NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
//            text =  nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
//        } else if([object.attachment isKindOfClass:[ML_GiftAttachment class]]) {
//            text = Localized(@"[礼物消息]", nil);
//        }
//        content = [[NSAttributedString alloc] initWithString:text];
//    }
//    else
//    {
//        content = [super contentForRecentSession:recent];
//    }
//    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
//    [self checkNeedAtTip:recent content:attContent];
//    [self checkOnlineState:recent content:attContent];
//    return attContent;
//}
//
//
//- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
//{
//    if ([NTESSessionUtil recentSessionIsMark:recent type:NTESRecentSessionMarkTypeAt]) {
//        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你]".ntes_localized attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//        [content insertAttributedString:atTip atIndex:0];
//    }
//}
//
//- (void)checkOnlineState:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
//{
//    if (recent.session.sessionType == NIMSessionTypeP2P) {
//        NSString *state  = [NTESSessionUtil onlineState:recent.session.sessionId detail:NO];
//        if (state.length) {
//            NSString *format = [NSString stringWithFormat:@"[%@] ",state];
//            NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:format attributes:nil];
//            [content insertAttributedString:atTip atIndex:0];
//        }
//    }
//}
//
//- (void)loadStickTopSessions
//{
//    __weak typeof(self) wself = self;
//    [NIMSDK.sharedSDK.chatExtendManager loadStickTopSessionInfos:^(NSError * _Nullable error, NSDictionary<NIMSession *,NIMStickTopSessionInfo *> * _Nullable infos) {
//        __strong typeof(self) sself = wself;
//        if (!sself) return;
//        sself.stickTopInfos = [NSMutableDictionary dictionaryWithDictionary:infos];
//        [sself refresh];
//    }];
//}
//
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if(@available(iOS 11.0, *)){
//
//
//        for (UIView *subview in self.tableView.subviews) {
//
//            if ([subview isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
//
//                for (UIView *view in subview.subviews) {
//
//                    for (UIView *view2 in view.subviews) {
//
//                        for (UIView *view3 in view2.subviews) {
//                            if ([view3 isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
//
//                                UIButton *deleteButton = [[UIButton alloc] initWithFrame:view3.bounds];
//
//                                [deleteButton setImage:[UIImage imageNamed:@"icon_shanchu_50_nor"] forState:UIControlStateNormal];
//                                [view3 addSubview:deleteButton];
//                                view3.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//                                view2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//                                break;
//                            }
//                        }
//                    }
//
//
//                }
//
//            }
//
//        }
//
//    }
//
//}
//
//
//
//@end
//
