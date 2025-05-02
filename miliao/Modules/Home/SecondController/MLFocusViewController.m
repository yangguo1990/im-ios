//
//  MLFocusViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLFocusViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
//#import "LYEmptyView/LYEmptyViewHeader.h"
#import "MLHomefocuslistTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_FocusBottomTableViewCell.h"
#import "ML_getTypeHostsApi.h"
#import "ML_ForyouApi.h"
#import "MLFocusApi.h"
#import "ML_HostdetailsViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ML_sayHelloApi.h"
#import "UIViewController+MLHud.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface MLFocusViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIImageView *ML_headview;
@property (nonatomic,strong)NSMutableArray *foryouArray;
@property (nonatomic, assign)int ML_Page;


@end

@implementation MLFocusViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self giveML_ForyouApi];
    [self giveheadML_focusApi];
    [self.ML_headview removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.ML_headview removeFromSuperview];
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(NSMutableArray *)foryouArray{
    if (_foryouArray == nil) {
        _foryouArray = [NSMutableArray array];
    }
    return _foryouArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];

}

-(void)giveheadML_focusApi{
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

-(void)giveML_focusApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"3" page:@(self.ML_Page) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSArray *arr = response.data[@"hosts"];
        if (arr.count == 0 && self.ML_Page == 1) {
            [self ML_setshowupUI];
            weakself.tableView.mj_footer.hidden = YES;
        }else{
            [self.ML_headview removeFromSuperview];
        }
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

-(void)giveML_ForyouApi{
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:currentData.token type:@"1" page:@"1" limit:@"3" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        self.foryouArray = response.data[@"hosts"];
        [self.ML_showTableview reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}


-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
        
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 50;
    emptyView.titleLabFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    emptyView.titleLabTextColor = [UIColor colorWithHexString:@"#666666"];
    //设置空内容占位图
    self.tableView.ly_emptyView = emptyView;

 }

-(void)ML_setshowupUI{
    [self.ML_headview removeFromSuperview];
    self.ML_headview = nil;
    self.ML_headview = [[UIImageView alloc]init];
    self.ML_headview.layer.masksToBounds = YES;
    self.ML_headview.image = kGetImage(@"card_recommendation_background_2");
    self.ML_headview.userInteractionEnabled = YES;
    self.ML_headview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.ML_headview];
    [self.ML_headview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(227);
    }];
    
    UIImageView *hotyouImg =[[UIImageView alloc]init];
    hotyouImg.image = [UIImage imageNamed:@"title_recommended_for_you"];
    [self.ML_headview addSubview:hotyouImg];
    [hotyouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headview.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.ML_headview.mas_top).mas_offset(16);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(98);
    }];
    

    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setBackgroundImage:[UIImage imageNamed:@"icon_guanbi_24_FFF_nor"] forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ML_headview addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ML_headview.mas_right).mas_offset(-12);
        make.centerY.mas_equalTo(hotyouImg.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
    
    self.ML_showTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ML_showTableview.delegate = self;
    self.ML_showTableview.dataSource = self;
    self.ML_showTableview.backgroundColor = [UIColor clearColor];
    self.ML_showTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.ML_headview addSubview:self.ML_showTableview];
    [self.ML_showTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(hotyouImg.mas_bottom).mas_offset(15);
    }];
        
}

-(void)cancelClick{
    
    [self.ML_headview removeFromSuperview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tableView isEqual:tableView]) {
        return self.data.count;
    }else{
        return self.foryouArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableView isEqual:tableView]) {
        __block MLHomefocuslistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell"];
        if (cell == nil) {
            cell = [[MLHomefocuslistTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listcell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dict = self.data[indexPath.row];
        cell.tag = indexPath.row;
        //cell.type = CityUITableViewCellfocus;
        [cell setClickCellVideoBlock:^(NSInteger index) {
            [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]] isCalled:NO];
        }];
        kSelf;
        [cell setClickbuttonBlock:^(NSInteger index) {
            
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:weakself.data[cell.tag]];
            [muDic setObject:@(1) forKey:@"call"];
            [weakself.data replaceObjectAtIndex:cell.tag withObject:muDic];
            
            NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:cell.tag inSection:0];
            NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
            [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        return cell;
    }else{
        __block ML_FocusBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ML_FocusBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;
        cell.dict = self.foryouArray[indexPath.row];
        [cell setAddCellTagBlock:^(NSInteger index) {

            
            [self.tableView.mj_header beginRefreshing];

            [self.ML_headview removeFromSuperview];
        }];
        return cell;
    }
}



//打招呼---
-(void)giveapitoUserId:(NSString *)toUserId{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:toUserId extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        [self showMessage:@"打招呼成功,可以给好友私信啦"];
        //[self giveML_focusApi];
        
        
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.ML_showTableview]) {
        return 100;
    }
    return 104;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView]) {
        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
        vc.dict = self.data[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
        vc.dict = self.foryouArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
