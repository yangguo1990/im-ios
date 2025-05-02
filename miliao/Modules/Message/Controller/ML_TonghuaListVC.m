

#import "ML_TonghuaListVC.h"
#import "ML_TonghuaViewCell.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "UIAlertView+NTESBlock.h"
@interface ML_TonghuaListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,assign) int ML_Page;
@property (nonatomic,assign) BOOL isBadgeViewHi;
@property (nonatomic,strong) NSMutableArray *listArr;
@end

@implementation ML_TonghuaListVC

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    self.view.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - SSL_TabbarHeight);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.ML_navView.hidden = YES;
    [self HY_addTableView];
    
    self.ML_TableView.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight - 10);
    
    self.ML_TableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

//    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5; // 设置长按时间阈值
    [self.ML_TableView addGestureRecognizer:longPressGesture];
    
    self.ML_titleLabel.text = Localized(@"通话记录", nil);
    
    kSelf;
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
//    self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
//
//        weakself.ML_Page ++;
//
//        [weakself requestData];
//    }];
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//        weakself.ML_Page ++;
//
//        [weakself requestData];
//
//    }];
//     [footer setTitle:@"—— 到底啦! ——" forState:MJRefreshStateNoMoreData];
//     footer.stateLabel.font = [UIFont systemFontOfSize:12];
//     footer.stateLabel.textColor = UIColorHex(0xB8BBBE);
//      footer.stateLabel.backgroundColor = [UIColor clearColor];
//     self.ML_TableView.mj_footer = footer;
    
    
    self.ML_TableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_Page = 1;
        
        [weakself requestData];
    }];
    
    [self.ML_TableView.mj_header beginRefreshing];


    
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.ML_TableView];
        NSIndexPath *indexPath = [self.ML_TableView indexPathForRowAtPoint:point];

        if (indexPath) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"删除该条最近通话？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
            [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
                switch (alertIndex) {
                    case 1:
                    {
                        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"id" : self.listArr[indexPath.row][@"id"]} urlStr:@"im/removeVideoCallLog"];
                        kSelf;
                        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                            
                            [weakself.listArr removeObjectAtIndex:indexPath.row];
                            
                            [weakself.ML_TableView beginUpdates];
                            [weakself.ML_TableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            [weakself.ML_TableView  endUpdates];

                            
//                            if (weakself.listArr.count) {
//                                NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//                                NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
//                                [weakself.ML_TableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//                            } else {
//                                [weakself.ML_TableView reloadData];
//                            }
                     
                        } error:^(MLNetworkResponse *response) {
                            
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        
                        
                        break;
                    }
                    default:
                        break;
                }
            }];
            
        }
    }
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
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"page" : @(self.ML_Page), @"limit" : @"20"} urlStr:@"im/videoCallList"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
        NSArray *arr = response.data[@"hosts"];
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.listArr removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
//            ML_CommunityModel *model = [ML_CommunityModel mj_objectWithKeyValues:dic];
            [weakself.listArr addObject:dic];
            
        }
//        if (arr.count) {
            [weakself.ML_TableView reloadData];
//        } else {
//            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
//        }
        
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
//        [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
        
    } failure:^(NSError *error) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
        [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ML_TonghuaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
    if(cell == nil) {
        cell =[[ML_TonghuaViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dict = self.listArr[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


@end
