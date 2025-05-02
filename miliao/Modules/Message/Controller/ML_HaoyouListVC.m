

#import "ML_HaoyouListVC.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "NIMMessageUtil.h"

@interface ML_HaoyouListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,assign) int ML_Page;
@property (nonatomic,assign) BOOL isBadgeViewHi;
@property (nonatomic,strong) NSMutableArray *listArr;
@end

@implementation ML_HaoyouListVC

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.ML_TableView.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight - 50 - 10);
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.ML_navView.hidden = YES;
    [self HY_addTableView];

    self.ML_TableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    
    kSelf;
    self.ML_TableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakself requestData];
    }];
    
}

- (NSMutableArray *)listArr
{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)requestData
{
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/mutualFriendList"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSArray *arr = response.data[@"hosts"];
        arr = [NSArray changeType:arr];
  
        
        [weakself.listArr removeAllObjects];
        
        __block int i = 0;
        for (NSDictionary *dic in arr) {
            
            NIMSession * session = [NIMSession session:[NSString stringWithFormat:@"%@", dic[@"userId"]] type:NIMSessionTypeP2P];
            
            [[NIMSDK sharedSDK].conversationManager fetchServerSessionBySession:session completion:^(NSError * _Nullable error, NIMRecentSession * _Nullable recentSession) {
                recentSession.serverExt = dic[@"icon"]?:@"";
                if (recentSession) {
                    [weakself.listArr addObject:recentSession];
                } else {
                    
                    [weakself.listArr addObject:dic];
                }
                if (i == arr.count-1) {
                    
                    [SVProgressHUD dismiss];
                    [weakself.ML_TableView reloadData];
                }
                
                i++;
            }];
            
            
        }
        if (arr.count) {
            [weakself.ML_TableView reloadData];
            [weakself.ML_TableView.mj_footer endRefreshing];
            [weakself.ML_TableView.mj_header endRefreshing];
        } else {
            [SVProgressHUD dismiss];
            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
    
        [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];

    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];

        [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];

    }];
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


- (void)dealloc
{
    if (self.RefreshContenBlock) {
        self.RefreshContenBlock(self.isBadgeViewHi);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.ML_TableView indexPathForCell:cell];
    
    id obj = self.listArr[indexPath.row];
    NSString *userId = nil;
    if ([obj isKindOfClass:[NIMRecentSession class]]) {
        
        NIMRecentSession *recent = (NIMRecentSession *)obj;
        userId = recent.session.sessionId;
    } else {
        userId = obj[@"userId"];
    }
    
    [self gotoInfoVC:userId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id obj = self.listArr[indexPath.row];
    NSString *userId = nil;
    if ([obj isKindOfClass:[NIMRecentSession class]]) {
        
        NIMRecentSession *recent = (NIMRecentSession *)obj;
        userId = recent.session.sessionId;
    } else {
        userId = obj[@"userId"];
    }
        
    [self gotoChatVC:userId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgBg.hidden = YES;
        
        
        cell.backgroundColor = [UIColor clearColor];

    }
    
    id obj = self.listArr[indexPath.row];
    cell.badgeView.hidden = YES;
    cell.timeLabel.hidden = YES;
//    cell.messageLabel.hidden = YES;
    if ([obj isKindOfClass:[NIMRecentSession class]]) {
        
        cell.timeLabel.hidden = NO;
        NIMRecentSession *recent = (NIMRecentSession *)obj;
        [cell.avatarImageView nim_setImageWithURL:kGetUrlPath(recent.serverExt) placeholderImage:nil];
        cell.nameLabel.text = [self nameForRecentSession:recent];
        cell.messageLabel.text  = [self messageContent:recent.lastMessage];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        if (recent.unreadCount) {
            cell.badgeView.hidden = NO;
            cell.badgeView.badgeValue = @(recent.unreadCount).stringValue;
        }else{
            cell.badgeView.hidden = YES;
        }
        
    } else {
        NSDictionary *dic = (NSDictionary *)obj;
//        cell.messageLabel.text  = dic[@"persionSign"];
        [cell.avatarImageView nim_setImageWithURL:kGetUrlPath(dic[@"icon"]) placeholderImage:nil];
        cell.nameLabel.text = dic[@"name"];
    }

    [cell.nameLabel sizeToFit];
    [cell.messageLabel sizeToFit];
    [cell.timeLabel sizeToFit];

    
        
    return cell;
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
    if (recent.lastMessage) {
        return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
    }
    // 服务端时间戳以毫秒为单位,需要转化
    NSTimeInterval timeSecond = recent.updateTime / 1000.0;
    return [NIMKitUtil showTime:timeSecond showDetail:NO];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 84;
}

@end
