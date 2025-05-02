//
//  ML_MyBillListVC.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ML_MyBillListVC.h"
#import "ML_BillCell.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface ML_MyBillListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *ML_TableView;
@property (nonatomic, strong) NSMutableArray *HY_ListArr;
@property (nonatomic, assign) int page;
@end

@implementation ML_MyBillListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HY_ListArr = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - 50) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.ML_TableView = tableView;
    
    self.page = 1;
    
    kSelf;
    self.ML_TableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
//        weakself.ML_TableView.mj_footer.state = MJRefreshStateIdle;
        [weakself.ML_TableView.mj_footer resetNoMoreData];
        weakself.page = 1;
        
        [weakself requestData];
    }];
    
    [self.ML_TableView.mj_header beginRefreshing];
    
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.page ++;

        [weakself requestData];
    }];

}

- (void)requestData
{
    
    NSString *urlPath = @"wallet/getRechargeLog";
    if (self.type == 1) {
        urlPath = @"wallet/getConsumeLog";
    } else if (self.type == 2) {
        urlPath = @"wallet/getCreditLog";
    } else if (self.type == 3) {
//        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
            urlPath = @"wallet/getWithdrawLog";
//        } else {
//
//            urlPath = @"wallet/getExchangeLog";
//        }
    }
    ML_CommonApi *api2 = [[ML_CommonApi alloc] initWithPDic:@{@"page" : @(self.page), @"limit" : @"20"} urlStr:urlPath];
    kSelf;
    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_header endRefreshing];
        [weakself.ML_TableView.mj_footer endRefreshing];
        NSDictionary *aDic = response.data;

        if (weakself.page==1) {
            [weakself.HY_ListArr removeAllObjects];
        }
        
        if (weakself.HY_ListArr.count >= [aDic[@"total"] integerValue]) {
            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            if (weakself.type == 0) {
                
                for (NSDictionary *model in aDic[@"rechargeLog"]) {
                    
                        [weakself.HY_ListArr addObject:model];
                }
                
            } else if (weakself.type == 1) {
                
                for (NSDictionary *model in aDic[@"consumeLog"]) {
                    
                        [weakself.HY_ListArr addObject:model];
                }
                
            } else if (weakself.type == 2) {
                for (NSDictionary *model in aDic[@"creditLogs"]) {
                    
                        [weakself.HY_ListArr addObject:model];
                }
            } else if (weakself.type == 3) {
                  
                    for (NSDictionary *model in aDic[@"withdrawLogs"]) {
                        
                            [weakself.HY_ListArr addObject:model];
                    }

            }
            [weakself.ML_TableView reloadData];
        }
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_header endRefreshing];
        [weakself.ML_TableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [weakself.ML_TableView.mj_header endRefreshing];
        [weakself.ML_TableView.mj_footer endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.HY_ListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ML_BillCell *cell = [ML_BillCell ML_cellWithTableView:tableView];
    cell.type = self.type;
    cell.dic = self.HY_ListArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {}

- (void)listDidDisappear {}

@end
