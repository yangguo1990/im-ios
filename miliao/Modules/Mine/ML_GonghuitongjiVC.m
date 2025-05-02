//
//  ML_MyBillListVC.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ML_GonghuitongjiVC.h"
#import "ML_tongjiCell.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface ML_GonghuitongjiVC ()<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *HY_ListArr;
@property (nonatomic, assign) int page;
@end

@implementation ML_GonghuitongjiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ML_titleLabel.text = Localized(@"公会统计数据", nil);
    
    self.HY_ListArr = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self HY_addTableView];
    self.ML_TableView.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight);
    self.page = 1;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 30)];
    self.ML_TableView.tableFooterView = view;
    
    kSelf;
    self.ML_TableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakself.ML_TableView.mj_footer resetNoMoreData];
        weakself.page = 1;
        
        [weakself requestData];
    }];
    
    [self.ML_TableView.mj_header beginRefreshing];
    
    self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.page ++;

        [weakself requestData];
    }];
}

- (void)requestData
{
    
    ML_CommonApi *api2 = [[ML_CommonApi alloc] initWithPDic:@{@"page" : @(self.page), @"limit" : @"20"} urlStr:@"user/getReportList"];
    kSelf;
    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSArray *arr = response.data[@"reports"];

        if (weakself.page==1) {
            [weakself.HY_ListArr removeAllObjects];
            //694px x 176px

            
        }
        for (NSDictionary *aD in arr) {
            
            [weakself.HY_ListArr addObject:aD];
        }
        
        if (weakself.HY_ListArr.count >= [response.data[@"total"] integerValue]) {
            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
            weakself.ML_TableView.mj_footer.hidden = YES;
        }
        
            
            [weakself.ML_TableView.mj_header endRefreshing];
            [weakself.ML_TableView.mj_footer endRefreshing];
            [weakself.ML_TableView reloadData];
        
        
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.HY_ListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ML_tongjiCell *cell = [ML_tongjiCell ML_cellWithTableView:tableView];
    cell.dic = self.HY_ListArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat H = ML_ScreenWidth * 88/347;
    
    int row = 3;
    CGFloat W2 = (ML_ScreenWidth - 48) / 3;
    CGFloat H2 = W2 * 88/W2;
    
    return H + (H2 * row) + 10 *(row-1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.HY_ListArr[section];
    return dic[@"date"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


@end
