//
//  ML_FriendFromViewController.m
//  miliao
//
//  Created by apple on 2022/9/14.
//

#import "ML_FriendFromViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_FocusBottomTableViewCell.h"
#import "MLGetUserAccessLogsApi.h"
#import "MLminefensiTableViewCell.h"
#import "ML_HostdetailsViewController.h"
#import "ML_sayHelloApi.h"
#import "UIViewController+MLHud.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "ML_NTableViewCell.h"
@interface ML_FriendFromViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIView *ML_headview;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic, assign)int ML_Page;
@property (nonatomic,strong)UIView *tableHeadView;


@end

@implementation ML_FriendFromViewController

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 60*mHeightScale)];
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_tableHeadView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(_tableHeadView.mas_centerY);
            make.width.mas_equalTo(90*mWidthScale);
            make.height.mas_equalTo(16*mHeightScale);
        }];
        iv.image = kGetImage(@"fangkeH");
    }
    return _tableHeadView;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    //[self giveML_focusApi];
    kSelf;
    self.tableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        weakself.ML_Page = 1;
        [weakself giveML_focusApi];
    }];
    [self.tableView.mj_header beginRefreshing];
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.tableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_focusApi];
    }];
}

//shui kan guo wo
-(void)giveML_focusApi{
    kSelf;
    MLGetUserAccessLogsApi *api = [[MLGetUserAccessLogsApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token type:@"1" page:@(self.ML_Page) limit:@"20" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSMutableArray *arr = response.data[@"accessLogs"];
        NSLog(@"%@",self.data);
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.data removeAllObjects];
        }
        
        for (NSDictionary *dic in arr) {
            [weakself.data addObject:dic];
        }
        if (arr.count) {
            [weakself.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [self.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakself.tableView.mj_header endRefreshing];
        }
        

        } error:^(MLNetworkResponse *response) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
        }];

}

-(void)setupUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    [self.tableView registerClass:[ML_NTableViewCell class] forCellReuseIdentifier:@"cell"];
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 30;
    //设置空内容占位图
    self.tableView.ly_emptyView = emptyView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_NTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = self.data[indexPath.row];
    cell.tag = indexPath.row;
    cell.isId = YES;
    cell.issearch=YES;
    cell.isguanzhu=NO;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102*mHeightScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
    
    NSMutableDictionary *nmdict = [NSMutableDictionary dictionary];
    //NSLog(@"dict--------%@",dict);
    //[nmdict setObject:@"15198698" forKey:@"userId"];
    [self.data[indexPath.row] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@ and obj = %@", key, obj);
        if ([key isEqualToString:@"id"]) {
            self.userId = obj;
            [nmdict removeObjectForKey:key];
        }
        [nmdict setObject:obj forKey:key];
    }];
    [nmdict setObject:self.userId forKey:@"userId"];
    [nmdict removeObjectForKey:@"id"];
     ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@", nmdict[@"userId"]]];
    vc.dict = nmdict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60*mHeightScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeadView;
}
//打招呼---
-(void)giveapitoUserId:(NSString *)toUserId btn:(UIButton *)btn{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:toUserId extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        [self showMessage:@"打招呼成功,可以给好友私信啦"];
        [btn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(28);
        }];
        //[self giveML_focusApi];
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.data[btn.tag]];
        [muDic setObject:@(1) forKey:@"call"];
        [self.data replaceObjectAtIndex:btn.tag withObject:muDic];
        
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}



@end
