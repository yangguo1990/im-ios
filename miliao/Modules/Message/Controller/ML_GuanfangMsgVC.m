

#import "ML_GuanfangMsgVC.h"
#import "ML_GuanfangMsgCell.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface ML_GuanfangMsgVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,assign) int ML_Page;
@property (nonatomic,assign) BOOL isBadgeViewHi;
@property (nonatomic,strong) NSMutableArray *listArr;
@end

@implementation ML_GuanfangMsgVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self HY_addTableView];
    self.ML_TableView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    
    
    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

    NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
    
    self.ML_titleLabel.text = dic1[@"name"]?:@"";
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"getPushMessage_%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
    if(arr.count) {
        self.listArr = [NSMutableArray arrayWithArray:arr];
        [self.ML_TableView reloadData];
    }
        
    kSelf;
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself requestData];
    }];
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

- (NSMutableArray *)listArr
{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)requestData
{
    // 获取官方推送消息列表
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"page" : @(self.ML_Page), @"limit" : @"50"} urlStr:@"push/getPushMessage"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        weakself.isBadgeViewHi = YES;
        
        
        NSArray *arr = response.data[@"messages"];
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.listArr removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
//            ML_CommunityModel *model = [ML_CommunityModel mj_objectWithKeyValues:dic];
            [weakself.listArr addObject:dic];
            
//            if (weakself.listArr.count > [response.data[@"total"] intValue]) {
//
//                [weakself.listArr removeLastObject];
//
//                break;
//            }
        }
        if (arr.count) {
            [weakself.ML_TableView reloadData];
            [weakself.ML_TableView.mj_footer endRefreshing];
            [weakself.ML_TableView.mj_header endRefreshing];
        } else {
            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        
//        weakself.listArr = [NSMutableArray arrayWithArray:response.data[@"messages"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:weakself.listArr forKey:[NSString stringWithFormat:@"getPushMessage_%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/official"/*@"push/getNewestPushMessage"*/];

        kSelf;
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
    __block ML_GuanfangMsgCell *cell = [ML_GuanfangMsgCell ML_cellWithTableView:tableView];
    
    
    cell.tag = indexPath.row;
    
    kSelf;
    cell.RefreshContenBlock = ^(NSDictionary *model) {
        
        [weakself.listArr replaceObjectAtIndex:cell.tag withObject:model];

        [tableView reloadData];
//        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
//
//        NSArray *indexArray=[NSArray  arrayWithObject:indexPath_1];
//
//        [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    cell.ML_Model = self.listArr[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ML_GuanfangMsgCell * cell = (ML_GuanfangMsgCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.cellHeight;
}


@end
