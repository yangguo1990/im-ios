//
//  NIMSessionListViewController2.m
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMSessionListViewController2.h"
#import "NIMSessionViewController.h"
#import "NIMSessionListCell.h"
#import "UIView+NIM.h"
#import "NIMAvatarImageView.h"
#import "NIMMessageUtil.h"
#import "NIMKitUtil.h"
#import "NIMKit.h"
#import "NIMBadgeView.h"
@interface NIMSessionListViewController2 ()

@end

@implementation NIMSessionListViewController2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imgBg = [[UIImageView alloc]initWithImage:kGetImage(@"bg_top")];
    imgBg.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_NavViewHeight + 110);
    imgBg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgBg];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
     
    extern NSString *const NIMKitTeamInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:NIMKitTeamInfoHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitTeamMembersHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:NIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:NIMKitUserInfoHasUpdatedNotification object:nil];
    
    [self setupSessions];
    
}

- (void)setupSessions {
    _recentSessions = [self getRecentSessions];
    if (!self.recentSessions.count)
    {
        _recentSessions = [NSMutableArray array];
    }
    else
    {
        _recentSessions = [self customSortRecents:_recentSessions];
    }
}

- (NSMutableArray *)getRecentSessions {
    return [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
}

- (void)refresh{
    if (!self.recentSessions.count) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
        [self customSortRecents:self.recentSessions];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
//    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];
//    if ([recentSession.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]) {
//        return NO;
//    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            NIMSessionDeleteAllRemoteMessagesOptions *options = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            options.removeOtherClients = YES;
            kSelf;
            [NIMSDK.sharedSDK.conversationManager deleteAllRemoteMessagesInSession:recentSession.session options:options completion:^(NSError * _Nullable error) {
                if (error) {
                    [weakself.view makeToast:[NSString stringWithFormat: @"删除失败:%@", error.localizedDescription]];
                    return;
                }
                [weakself onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
            }];
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.imgBg.hidden = YES;
    
//    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
//    } else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    
    
    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    
    NIMSession *session = recent.session;
    
    cell.messageLabel.attributedText = nil;
    cell.messageLabel.text = nil;
    
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    
    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];

    NSDictionary *newestMsgDic = dic1[@"newestMsg"];
    
    NSDictionary *dic0 = userData.officialInfo[@"officialServInfo"];

//    if ([session.sessionId isEqualToString:dic1[@"name"]]) {
    if ([session.sessionId caseInsensitiveCompare:dic1[@"name"]]==NSOrderedSame) {
        cell.nameLabel.text = [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
        [cell.nameLabel sizeToFit];
        [cell.avatarImageView nim_setImageWithURL:kGetUrlPath(dic1[@"icon"]) placeholderImage:nil];
        NSDictionary *messageDic = newestMsgDic[@"message"];
        cell.timeLabel.text = [NIMKitUtil showTime:([messageDic[@"createTime"] longValue]/1000) showDetail:NO];
        [cell.timeLabel sizeToFit];
        NSDictionary *dataDic = messageDic[@"data"];
//        cell.messageLabel.attributedText  = [[NSAttributedString alloc] initWithString:dataDic[@"content"] ?: @""];
        cell.messageLabel.text  = dataDic[@"content"] ?: @"";
        [cell.messageLabel sizeToFit];
        cell.badgeView.badgeValue = [NSString stringWithFormat:@"%@", newestMsgDic[@"notRead"]];
    }  else {
        cell.nameLabel.text = [self nameForRecentSession:recent];
        [cell.nameLabel sizeToFit];
        if ([session.sessionId isEqualToString:[NSString stringWithFormat:@"%@", dic0[@"id"]]]) {
            [cell.avatarImageView nim_setImageWithURL:kGetUrlPath(dic0[@"icon"]) placeholderImage:nil];
        } else {
            
            [cell.avatarImageView setAvatarBySession:recent.session];
        }
//        cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
        cell.messageLabel.text  = [self messageContent:recent.lastMessage];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        [cell.timeLabel sizeToFit];
    }
   
    
    [cell refresh:recent];
//    if ([session.sessionId isEqualToString:dic1[@"name"]]) {
    if ([session.sessionId caseInsensitiveCompare:dic1[@"name"]]==NSOrderedSame) {
        
        cell.badgeView.hidden = ![newestMsgDic[@"notRead"] boolValue];
        
        if (self.isBadgeViewHi) {
            cell.badgeView.hidden = YES;
        }
    }
    
    return cell;
}

- (void)setIsBadgeViewHi:(BOOL)isBadgeViewHi
{
    _isBadgeViewHi = isBadgeViewHi;
    kSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.isBadgeViewHi = NO;
    });
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didLoadAllRecentSessionCompletion {
    [self setupSessions];
    
    [self refresh];
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self.recentSessions addObject:recentSession];
    [self sort];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    for (NIMRecentSession *recent in self.recentSessions)
    {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId])
        {
            [self.recentSessions removeObject:recent];
            break;
        }
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    //清理本地数据
    [self.recentSessions removeObject:recentSession];
    
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession)
    {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                           completion:nil];
    }
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)allMessagesDeleted{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)allMessagesRead
{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions
{
    return self.recentSessions;
}

#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        [self refresh];
    }
}

#pragma mark - Override
- (void)onSelectedAvatar:(NSString *)userId
             atIndexPath:(NSIndexPath *)indexPath{};

- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath{
    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recentSession.session];
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSString *)nameForRecentSession:(NIMRecentSession *)recent {
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    } else if (recent.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    } else if (recent.session.sessionType == NIMSessionTypeSuperTeam) {
        NIMTeam *superTeam = [[NIMSDK sharedSDK].superTeamManager teamById:recent.session.sessionId];
        return superTeam.teamName;
    } else {
        NSAssert(NO, @"");
        return nil;
    }
}

- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSString *content = [self messageContent:recent.lastMessage];
    return [[NSAttributedString alloc] initWithString:content ?: @""];
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
    if (recent.lastMessage) {
        return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
    }
    // 服务端时间戳以毫秒为单位,需要转化
    NSTimeInterval timeSecond = recent.updateTime / 1000.0;
    return [NIMKitUtil showTime:timeSecond showDetail:NO];
}

#pragma mark - Misc

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.recentSessions.count;
    }
}

- (void)sort{
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    [self onSelectedAvatar:recent atIndexPath:indexPath];
}



#pragma mark - Private
- (NSString *)messageContent:(NIMMessage*)lastMessage{
    NSString *text = [NIMMessageUtil messageContent:lastMessage];
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip)
    {
        return text;
    }
    else
    {
        NSString *from = lastMessage.from;
        NSString *nickName = [NIMKitUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

#pragma mark - Notification
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}

- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}

- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}



@end
