//
//  MLMineDynameicViewController.m
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLMineDynameicViewController.h"
#import <Masonry/Masonry.h>
#import "FriendTableViewCell.h"
#import "MLFriendViewController.h"
#import "MLGetUserDynaimcsApi.h"
#import <SDWebImage/SDWebImage.h>
#import "UIViewController+MLHud.h"
#import "YNNavigationController.h"
#import "MLMineDynameTableViewCell.h"
#import "MLMineDynameDeatViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "MLGetUserDynamicApi.h"
#import <MJRefresh/MJRefresh.h>
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "ML_CommunityCell.h"
#import "ML_CommunityModel.h"
@interface MLMineDynameicViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic, assign)int ML_Page;

@end

@implementation MLMineDynameicViewController

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.data removeAllObjects];
    //[self giveML_FriendModelApi];
}

-(void)giveML_FriendModelApi{
    kSelf;
    if (!self.userId) {
        MLGetUserDynaimcsApi *api = [[MLGetUserDynaimcsApi alloc]initWithtotoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@(self.ML_Page) limit:@"20" extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            //NSLog(@"%@",response.data[@"dynamics"]);
            //self.data = response.data[@"dynamics"];
            //[self.tab reloadData];
            NSMutableArray *arr = response.data[@"dynamics"];
            NSLog(@"%@",weakself.data);
            arr = [NSArray changeType:arr];
            if (weakself.ML_Page == 1) {
                [weakself.data removeAllObjects];
            }
            
            for (NSDictionary *dic in arr) {
                [weakself.data addObject:dic];
            }
            if (arr.count) {
                [weakself.tab reloadData];
                [weakself.tab.mj_footer endRefreshing];
                [weakself.tab.mj_header endRefreshing];
            } else {
                [self.tab reloadData];
                [weakself.tab.mj_footer endRefreshingWithNoMoreData];
                [weakself.tab.mj_header endRefreshing];
            }
            if (arr.count == 0 && weakself.ML_Page == 1) {
                weakself.tab.mj_footer.hidden = YES;
            }else{
                weakself.tab.mj_footer.hidden = NO;
            }
        } error:^(MLNetworkResponse *response) {
            [weakself.tab.mj_footer endRefreshing];
            [weakself.tab.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [weakself.tab.mj_footer endRefreshing];
            [weakself.tab.mj_header endRefreshing];
        }];
       
    }else{

        MLGetUserDynamicApi *api = [[MLGetUserDynamicApi alloc] initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@(self.ML_Page) toUserId:self.userId];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            NSLog(@"个人动态--%@",response.data);
            NSMutableArray *arr = response.data[@"dynamics"];
            NSLog(@"%@",weakself.data);
            arr = [NSArray changeType:arr];
            if (weakself.ML_Page == 1) {
                [weakself.data removeAllObjects];
            }
            
            for (NSDictionary *dic in arr) {
                [weakself.data addObject:dic];
            }
            if (arr.count) {
                [weakself.tab reloadData];
                [weakself.tab.mj_footer endRefreshing];
                [weakself.tab.mj_header endRefreshing];
            } else {
                [self.tab reloadData];
                [weakself.tab.mj_footer endRefreshingWithNoMoreData];
                [weakself.tab.mj_header endRefreshing];
            }
            if (arr.count == 0 && weakself.ML_Page == 1) {
                weakself.tab.mj_footer.hidden = YES;
            }else{
                weakself.tab.mj_footer.hidden = NO;
            }
        } error:^(MLNetworkResponse *response) {
            [weakself.tab.mj_footer endRefreshing];
            [weakself.tab.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [weakself.tab.mj_footer endRefreshing];
            [weakself.tab.mj_header endRefreshing];
        }];
}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    
    kSelf;
    self.tab.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        weakself.ML_Page = 1;
        [weakself giveML_FriendModelApi];
    }];
    [self.tab.mj_header beginRefreshing];
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_FriendModelApi];
    }];

    
    if (!self.userId) {
        self.ML_titleLabel.text = Localized(@"我的动态", nil);

        
    }else{
        self.ML_titleLabel.text = [NSString stringWithFormat:@"%@的动态",self.userName];
    }
    //self.yn_banRightSliderGesture = YES;
  
}

-(void)setupUI{
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:tab];
    self.tab = tab;
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
    
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 30;
    //设置空内容占位图
    self.tab.ly_emptyView = emptyView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_CommunityCell *cell = [ML_CommunityCell ML_cellWithTableView:tableView];
    NSDictionary *dic =  self.data[indexPath.row];
    ML_CommunityModel *model0 =  [ML_CommunityModel mj_objectWithKeyValues:dic];
    model0.username = dic[@"name"];
    model0.isLike = dic[@"like"];
    model0.index = indexPath.row;
    model0.likesCount = dic[@"likeCount"];
    model0.createTime = dic[@"aduitTime"];
    model0.location = @"";
    cell.ML_LoveBtn.hidden = YES;
    cell.shipBt.hidden = YES;
    cell.ML_Model = model0;


    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMineDynameDeatViewController *vc = [[MLMineDynameDeatViewController alloc]init];
    vc.dict = self.data[indexPath.row];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_CommunityCell * cell = (ML_CommunityCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.cellHeight;
}


@end
