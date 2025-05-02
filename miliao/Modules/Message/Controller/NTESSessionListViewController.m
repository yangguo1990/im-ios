//
//  NTESSessionListViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionListViewController.h"
#import "ML_GuanfangMsgVC.h"
#import "NTESSessionPeekViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESListHeader.h"
#import "NTESClientsTableViewController.h"
#import "NTESSessionUtil.h"
#import "NTESPersonalCardViewController.h"
#import "NTESMessageUtil.h"
#import "ML_SessionViewController.h"
#import "NTESSessionSearchViewController.h"
#import "NSString+NTES.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Toast/UIView+Toast.h>
#import "UIAlertView+NTESBlock.h"
#import "UIActionSheet+NTESBlock.h"

#define SessionListTitle @"云信 Demo".ntes_localized

@interface NTESSessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate,NIMEventSubscribeManagerDelegate,UIViewControllerPreviewingDelegate,NIMChatExtendManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic,strong) UIImageView *emptyTipImgV;
@property (nonatomic,strong) NTESListHeader *header;
@property (nonatomic,strong) NSString *zhiSessionId;
@property (nonatomic,assign) BOOL supportsForceTouch;
@property (nonatomic,strong) NSIndexPath *indexPathZhi;
@property (nonatomic,strong) NSMutableDictionary *previews;

@property (nonatomic,strong) NSMutableDictionary<NIMSession *,NIMStickTopSessionInfo *> *stickTopInfos;


@end

@implementation NTESSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _previews = [[NSMutableDictionary alloc] init];
        self.stickTopInfos = NSMutableDictionary.dictionary;
        self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatExtendManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)officialNot
{
    [self refresh];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/official"/*@"push/getNewestPushMessage"*/];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        if (response.data != nil) {
            UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
            userData.officialInfo = response.data;
            [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
            [weakself refresh];
        }
    } error:^(MLNetworkResponse *response) {
        NSLog(@"%@", response);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
    
    self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    self.ML_navView.hidden = YES;
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    [[NIMSDK sharedSDK].chatExtendManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];

    self.header = [[NTESListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    self.header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.header.delegate = self;
    [self.view addSubview:self.header];

    UIImageView *emptyTipImgV = [[UIImageView alloc] initWithImage:kGetImage(@"queshengzhi")];
    emptyTipImgV.center = CGPointMake(ML_ScreenWidth / 2, 300);
    [self.view addSubview:emptyTipImgV];
    self.emptyTipImgV = emptyTipImgV;
    
    self.emptyTipImgV.hidden = !(self.recentSessions.count>2);
    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    self.navigationItem.titleView  = [self titleView:userID];
    self.definesPresentationContext = YES;
//    [self setUpNavItem];
    
    ADD_NOTIFICATION(@"ClickedMoreBtn", self, @selector(ClickedMoreBtn), nil);
    ADD_NOTIFICATION(@"officialNot", self, @selector(officialNot), nil);
    
    NIMAddEmptyRecentSessionBySessionOption * op = [NIMAddEmptyRecentSessionBySessionOption new];
    NIMSession * session1 = [NIMSession session:@"1000000" type:NIMSessionTypeP2P];
     [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session1 option:op];
    
    NIMAddEmptyRecentSessionBySessionOption * op2 = [NIMAddEmptyRecentSessionBySessionOption new];
    NIMSession * session2 = [NIMSession session:@"100000" type:NIMSessionTypeP2P];
     [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session2 option:op2];
    
    
    [self getZhiding];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5; // 设置长按时间阈值
    [self.tableView addGestureRecognizer:longPressGesture];

}


- (void)getZhiding
{

    
    NIMAddEmptyRecentSessionBySessionOption * op = [NIMAddEmptyRecentSessionBySessionOption new];
    NIMSession * session1 = [NIMSession session:@"1000000" type:NIMSessionTypeP2P];
   NIMAddStickTopSessionParams *params1 = [[NIMAddStickTopSessionParams alloc] initWithSession:session1];
   
   __weak typeof(self) wself = self;
   [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params1 completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
       __weak typeof(self) sself = wself;
       if (!sself) return;
       if (error) {
           [SVProgressHUD showErrorWithStatus:error.localizedDescription];
           return;
       }
       self.stickTopInfos[newInfo.session] = newInfo;
//       [self refresh];
       
       
       NIMSession *session = [NIMSession session:@"100000" type:NIMSessionTypeP2P];
       NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:session];
       [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
           __weak typeof(self) sself = wself;
           if (!sself) return;
           if (error) {
               [SVProgressHUD showErrorWithStatus:error.localizedDescription];
               return;
           }
           self.stickTopInfos[newInfo.session] = newInfo;
           [self refresh];
       }];
       
   }];
   
       
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadStickTopSessions];
    
    
}

- (void)refresh{
    
    [super refresh];
    self.emptyTipImgV.hidden = YES;
//    self.emptyTipLabel.hidden = self.recentSessions.count;
}

- (NSMutableArray *)setupAlertActions {
    UIAlertAction *markAllMessagesReadAction = [UIAlertAction actionWithTitle:@"标记所有消息为已读".ntes_localized
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
          [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
    }];
    
    UIAlertAction *cleanAllMessagesAction = [UIAlertAction actionWithTitle:@"清理所有消息".ntes_localized
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
           BOOL removeRecentSessions = [NTESBundleSetting sharedConfig].removeSessionWhenDeleteMessages;
           BOOL removeTables = [NTESBundleSetting sharedConfig].dropTableWhenDeleteMessages;
           
           NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
           option.removeSession = removeRecentSessions;
           option.removeTable = removeTables;
           
           [[NIMSDK sharedSDK].conversationManager deleteAllMessages:option];
    }];
    

    UIAlertAction *allServerSessions = [UIAlertAction actionWithTitle:@"查看云端会话".ntes_localized
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
//        NTESSessionServiceListVC * vc = [[NTESSessionServiceListVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消".ntes_localized
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    return @[markAllMessagesReadAction, cleanAllMessagesAction, allServerSessions, cancel].mutableCopy;
}

- (void)more:(id)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *actions = [self setupAlertActions];
    for (UIAlertAction *action in actions) {
        [vc addAction:action];
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)ClickedMoreBtn
{
    
    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
    tanV.dic = @{@"type" : @(ML_TanchuangViewType_MsgListVCMore)};
    tanV.ML_TanchuangClickBlock = ^(NSInteger tag) {
        if (tag == 1) {
            
            NSArray * tempArray = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
//            NSMutableArray * shouldDeleteSessons = [NSMutableArray array]; // 过滤不用删除的
//            for(NIMRecentSession * recentSession in tempArray){
//                if (![recentSession.delete_disabled isEqualToString:@"1"]) {
//                    [shouldDeleteSessons addObject:recentSession];
//                }
//            }
            
            for(NIMRecentSession * forSession in tempArray){
                dispatch_async(dispatch_get_main_queue(), ^{
                    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
                    
                    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
                    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
                    
                    if (![forSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]] && ![forSession.session.sessionId isEqualToString:@"1000000"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
//                                UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//                                NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//                                NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//
                            BOOL isTop = self.stickTopInfos[forSession.session] != nil;
                            if (!isTop) {
                                
                                id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
                                [manager markAllMessagesReadInSession:forSession.session];
                                NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
                                options.removeOtherClients = YES;
                                kSelf;
                                [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:forSession.session options:options completion:^(NSError * _Nullable error) {
                                    if (error) {
                                        
                                        [weakself.view makeToast:[NSString stringWithFormat: @"%@:%@", Localized(@"删除失败", nil), error.localizedDescription]];
                                        return;
                                    }
                                }];

                                [manager deleteRecentSession:forSession];
                                [self refresh];
//                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//                                    extern NSString *NTESCustomNotificationCountChanged;
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];

                            }
                        });
                        
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
                        
                    }
                });
            }
        
            
        } else if (tag == 2) {
//            [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
            
            UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

                NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
                NSDictionary *newestMsgDic = dic1[@"newestMsg"];
            
            extern NSString *NTESCustomNotificationCountChanged;
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:newestMsgDic[@"notRead"]];
//            self.isBadgeViewHi = YES;
            [self refresh];
            
            [[NIMSDK sharedSDK].conversationManager markAllMessagesRead];
            
            // 全部已读数据太多情况下调用这个是不行的
            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"push/getPushMessage"];
            kSelf;
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                
                
                
                ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/official"/*@"push/getNewestPushMessage"*/];

                kSelf;
                [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    
                    if (response.data != nil) {
                        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                        userData.officialInfo = response.data;
                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
                        [weakself refresh];
                    }
                } error:^(MLNetworkResponse *response) {

                } failure:^(NSError *error) {
                    
                }];
                
                
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
                
            }];
            
        }
    };
//
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
//                                                                message:nil
//                                                         preferredStyle:UIAlertControllerStyleActionSheet];
//
//    NSArray *actions = [self setupAlertActions];
//    for (UIAlertAction *action in actions) {
//        [vc addAction:action];
//    }
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    if ([recent.session.sessionId isEqualToString:@"1000000"]) {
        
        ML_GuanfangMsgVC *vc = [ML_GuanfangMsgVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        ML_SessionViewController *vc = [[ML_SessionViewController alloc] initWithSession:recent.session];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        [self gotoInfoVC:recent.session.sessionId];
    }
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

- (void)onTopRecentAtIndexPath:(NIMRecentSession *)recent
                   atIndexPath:(NSIndexPath *)indexPath
                         isTop:(BOOL)isTop
{
    if (isTop)
    {
        __weak typeof(self) wself = self;
        [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:self.stickTopInfos[recent.session] completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
            __weak typeof(self) sself = wself;
            if (!sself) return;
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                return;
            }
            self.stickTopInfos[recent.session] = nil;
            [self refresh];
        }];
    } else {
        __weak typeof(self) wself = self;
        NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:recent.session];
        [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
            __weak typeof(self) sself = wself;
            if (!sself) return;
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                return;
            }
            self.zhiSessionId = recent.session.sessionId;
            
            self.stickTopInfos[newInfo.session] = newInfo;
            
            
            
            [self getZhiding];
//            [self refresh];
        }];
        
        
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑".ntes_localized;
    }
    return [super nameForRecentSession:recent];
}


- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions
{
        [NIMSDK.sharedSDK.chatExtendManager sortRecentSessions:recentSessions withStickTopInfos:self.stickTopInfos];
        return recentSessions;
    
//    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//
//    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//
//    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//
//    // 保证官方消息在第二
//    NSMutableArray * theRecentSessionArray = [NSMutableArray arrayWithArray:self.recentSessions];
    NIMRecentSession * theRecentSession = nil;
//    NIMRecentSession * theRecentSession2 = nil;
    int i = 0;
    for(NIMRecentSession * tSession in self.recentSessions){
        if(![self.zhiSessionId isEqualToString:tSession.session.sessionId] && recentSessions.count >= 2){
            theRecentSession = tSession;
            [self.recentSessions removeObject:tSession];
           
                [self.recentSessions insertObject:theRecentSession atIndex:2];
            
//            if (theRecentSession && theRecentSession2) {
                break;
//            }
        }
        i++;
//
////        if([tSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]){
//        if([tSession.session.sessionId isEqualToString:@"100000"]){
//            theRecentSession2 = tSession;
//            [theRecentSessionArray removeObject:tSession];
//
//            if (theRecentSession && theRecentSession2) {
//                break;
//            }
//        }
//
    }
    
//    self.recentSessions = theRecentSessionArray;
//    return self.recentSessions;
    
//    if (theRecentSession) {
//
//        [theRecentSessionArray insertObject:theRecentSession atIndex:0];
//    }
//    if (theRecentSession2) {
//
//        [theRecentSessionArray insertObject:theRecentSession2 atIndex:0];
//    }

//    self.recentSessions = theRecentSessionArray;
//    return self.recentSessions;
    [NIMSDK.sharedSDK.chatExtendManager sortRecentSessions:self.recentSessions withStickTopInfos:self.stickTopInfos];
    return self.recentSessions;
}
//- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions
//{
//    [NIMSDK.sharedSDK.chatExtendManager sortRecentSessions:recentSessions withStickTopInfos:self.stickTopInfos];
//    return recentSessions;
//}

#pragma mark - SessionListHeaderDelegate

- (void)didSelectRowType:(NTESListHeaderType)type{
    //多人登录
    switch (type) {
        case ListHeaderTypeLoginClients:{
            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)".ntes_localized];
            break;
        case NIMLoginStepLinking:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)".ntes_localized];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)".ntes_localized];
            break;
        default:
            break;
    }
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
    [self refreshSubview];
}

- (void)onMultiLoginClientsChanged
{
    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
    [self refreshSubview];
}

- (void)onTeamUsersSyncFinished:(BOOL)success
{
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:cell];
        [self.previews setObject:preview forKey:@(indexPath.row)];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self.previews objectForKey:@(indexPath.row)];
        [self unregisterForPreviewingWithContext:preview];
        [self.previews removeObjectForKey:@(indexPath.row)];
    }
}


- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
    UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
        return nav;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
//        [self.navigationController showViewController:vc sender:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 偶现侧滑数组越界，但并没有发现并发问题，暂且防护
    return indexPath.row < self.recentSessions.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Localized(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
        [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
        [tableView setEditing:NO animated:YES];
        
        // 删除置顶
        NIMStickTopSessionInfo *stickTopInfo = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:recentSession.session];
        if (stickTopInfo) {
            [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:stickTopInfo completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
                __strong typeof(self) sself = weakSelf;
                if (!sself) return;
                if (!error) {
                    self.stickTopInfos[recentSession.session] = nil;
                }
            }];
        }
    }];
    
    
    NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
    BOOL isTop = self.stickTopInfos[recentSession.session] != nil;
    UITableViewRowAction *top = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:isTop?Localized(@"取消置顶", nil):Localized(@"置顶", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf onTopRecentAtIndexPath:recentSession atIndexPath:indexPath isTop:isTop];
        [tableView setEditing:NO animated:YES];
    }];
    
    return @[delete,top];
}

- (void)imageTapped:(UIGestureRecognizer *)gr
{
    [gr.view removeFromSuperview];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath.row == 0 || indexPath.row == 1) {
            return ;
        }
        if (indexPath) {
            
            NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
            BOOL isTop = self.stickTopInfos[recentSession.session] != nil;
            
            NSArray * tempArray = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:Localized(@"选择", nil) delegate:nil cancelButtonTitle:Localized(@"取消", nil).ntes_localized destructiveButtonTitle:nil otherButtonTitles:isTop?Localized(@"取消置顶该聊天", nil):Localized(@"置顶该聊天", nil), Localized(@"删除该聊天", nil), nil];
            [sheet showInView:self.view completionHandler:^(NSInteger index) {
                switch (index) {
                    case 0:
                        
                        [self onTopRecentAtIndexPath:recentSession atIndexPath:indexPath isTop:isTop];
                        break;
                    case 1:
                        
                        
                        for(NIMRecentSession * forSession in tempArray){
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//                                NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
//                                NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//
                                if ([forSession.session.sessionId isEqualToString:recentSession.session.sessionId]) {
                                    
                                    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
                                    [manager markAllMessagesReadInSession:forSession.session];
                                    NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
                                    options.removeOtherClients = YES;
                                    kSelf;
                                    [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:recentSession.session options:options completion:^(NSError * _Nullable error) {
                                        if (error) {
                                            
                                            [weakself.view makeToast:[NSString stringWithFormat: @"%@:%@", Localized(@"删除失败", nil), error.localizedDescription]];
                                            return;
                                        }
                                    }];

                                    [manager deleteRecentSession:forSession];
                                    [self refresh];
//                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
//                                    extern NSString *NTESCustomNotificationCountChanged;
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];

                                }
                            });
                        }
                    
                        
                        
                        break;
                    default:
                        break;
                }
            }];
            
            return;
            
            self.indexPathZhi = indexPath;
                        UIView *view3 = [[UIView alloc] initWithFrame:self.view.window.bounds];
            view3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
            [self.view.window addSubview:view3];
            
            UIView *imgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth - 50, 90)];
            imgV.backgroundColor = [UIColor whiteColor];
            imgV.layer.cornerRadius = 10; imgV.layer.masksToBounds = YES;
            [view3 addSubview:imgV];
            imgV.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            [view3 addGestureRecognizer:tapGesture];
      
       UIView *live = [[UIView alloc] initWithFrame:CGRectMake(20, 44.5, imgV.width - 40, 1)];
            live.backgroundColor = [UIColor blackColor];
       [imgV addSubview:live];
            
            
            UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgV.width, 45)];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn3 setTitle:isTop?Localized(@"取消置顶该聊天", nil):Localized(@"置顶该聊天", nil) forState:UIControlStateNormal];
            btn3.tag = isTop;
            [btn3 addTarget:self action:@selector(zhiQingClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn3];
            
            UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, imgV.width, 45)];
            [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn4.tag = 12;
            [btn4 setTitle:Localized(@"删除该聊天", nil) forState:UIControlStateNormal];
            [btn4 addTarget:self action:@selector(zhiQingClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn4];
            
            
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:isTop?Localized(@"确定取消置顶当前用户", nil):Localized(@"确定置顶当前用户？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
//            [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
//                switch (alertIndex) {
//                    case 1:
//                    {
//                        break;
//                    }
//                    default:
//                        break;
//                }
//            }];
            
            NSLog(@"长按");
        }
    }
}

- (void)zhiQingClick:(UIButton *)btn
{
    if(btn.tag == 12) {
        
    } else {
        if (self.indexPathZhi) {
            NIMRecentSession *recentSession = self.recentSessions[self.indexPathZhi.row];
            [self onTopRecentAtIndexPath:recentSession atIndexPath:self.indexPathZhi isTop:btn.tag];
        }
    }
}


#pragma mark - NIMEventSubscribeManagerDelegate

- (void)onRecvSubscribeEvents:(NSArray *)events
{
    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NIMSubscribeEvent *event in events) {
        [ids addObject:event.from];
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        if (recent.session.sessionType == NIMSessionTypeP2P) {
            NSString *from = recent.session.sessionId;
            if ([ids containsObject:from]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onNotifyAddStickTopSession:(NIMStickTopSessionInfo *)newInfo
{
    self.stickTopInfos[newInfo.session] = newInfo;
    [self refresh];
}

- (void)onNotifyRemoveStickTopSession:(NIMStickTopSessionInfo *)removedInfo
{
    self.stickTopInfos[removedInfo.session] = nil;
    [self refresh];
}

- (void)onNotifySyncStickTopSessions:(NIMSyncStickTopSessionResponse *)response
{
    if (response.hasChange) {
        [self.stickTopInfos removeAllObjects];
        [response.allInfos enumerateObjectsUsingBlock:^(NIMStickTopSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.stickTopInfos[obj.session] = obj;
        }];
        [self refresh];
    }
}

#pragma mark - NIMConversationManagerDelegate
- (void)onMarkMessageReadCompleteInSession:(NIMSession *)session error:(NSError *)error {
    if (error) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        NSString *msg = [NSString stringWithFormat:@"session %@ type %@ mark fail.code:%@",
                         session.sessionId, @(session.sessionType), @(error.code)];
        [keyWindow makeToast:msg duration:2 position:CSToastPositionCenter];
    }
}

#pragma mark - Private

- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    if (@available(iOS 11.0, *))
    {
//        self.header.top = self.view.safeAreaInsets.top;
//        self.tableView.top = self.header.bottom;
//        CGFloat offset = self.view.safeAreaInsets.bottom;
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
        
        self.tableView.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight - 50);
        
    }
    else
    {
//        self.tableView.top = self.header.height;
//        self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
        self.tableView.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_TabbarHeight - 50);
        
    }
    self.tableView.height = self.view.height - self.tableView.top;
    
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f;
    self.emptyTipLabel.width = self.emptyTipLabel.width < self.view.width ? self.emptyTipLabel.width : self.view.width - 5;
    CGSize size = [self.emptyTipLabel sizeThatFits:CGSizeMake(self.emptyTipLabel.width, CGFLOAT_MAX)];
    self.emptyTipLabel.height = size.height;
}

- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  SessionListTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    return titleView;
}


- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSAttributedString *content;
    if (recent.lastMessage.messageType == NIMMessageTypeCustom)
    {
        NSString *text = [NTESMessageUtil messageContent:recent.lastMessage];
        if (recent.session.sessionType != NIMSessionTypeP2P)
        {
            NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
            text =  nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
        }
        content = [[NSAttributedString alloc] initWithString:text];
    }
    else
    {
        content = [super contentForRecentSession:recent];
    }
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    [self checkNeedAtTip:recent content:attContent];
    [self checkOnlineState:recent content:attContent];
    return attContent;
}


- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if ([NTESSessionUtil recentSessionIsMark:recent type:NTESRecentSessionMarkTypeAt]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你]".ntes_localized attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [content insertAttributedString:atTip atIndex:0];
    }
}

- (void)checkOnlineState:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        NSString *state  = [NTESSessionUtil onlineState:recent.session.sessionId detail:NO];
        if (state.length) {
            NSString *format = [NSString stringWithFormat:@"[%@] ",state];
            NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:format attributes:nil];
            [content insertAttributedString:atTip atIndex:0];
        }
    }
}

- (void)loadStickTopSessions
{
    __weak typeof(self) wself = self;
    [NIMSDK.sharedSDK.chatExtendManager loadStickTopSessionInfos:^(NSError * _Nullable error, NSDictionary<NIMSession *,NIMStickTopSessionInfo *> * _Nullable infos) {
        __strong typeof(self) sself = wself;
        if (!sself) return;
        sself.stickTopInfos = [NSMutableDictionary dictionaryWithDictionary:infos];
        [sself refresh];
    }];
}

@end
