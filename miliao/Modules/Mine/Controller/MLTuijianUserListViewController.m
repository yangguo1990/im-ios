//
//  MLTuijianUserListViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLTuijianUserListViewController.h"
#import "MLTuijianuserlistTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MLGetInviteUserApi.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
//#import "MLSearchViewController.h"
#import "ML_SearchBar.h"

@interface MLTuijianUserListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)NSMutableArray *tpData;
@end

@implementation MLTuijianUserListViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self giveML_getTypeHostsApi];
}

-(void)giveML_getTypeHostsApi{
    MLGetInviteUserApi *api = [[MLGetInviteUserApi alloc] initWithtotoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@"1" limit:@"50" type:[NSString stringWithFormat:@"%d", self.type] key:nil extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"---%@",response.data);
        self.data = response.data[@"users"];
        [self.tablview reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"邀请的用户", nil);
    if (self.type == 1) {
        
        self.ML_titleLabel.text = Localized(@"认证的用户", nil);
    } else if (self.type == 2) {
        
        self.ML_titleLabel.text = Localized(@"充值的用户", nil);
    }
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    
//    [self.ML_rightBtn setImage:kGetImage(@"icon_search_333_24_nor") forState:UIControlStateNormal];
    
}

- (void)ML_rightItemClicked
{
    

}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
//        self.tablview.hidden = YES;
        if (self.tpData.count) {
            self.data = self.tpData;
        }
        [self.tablview reloadData];
    }else{
        self.tpData = [NSMutableArray arrayWithArray:self.data];
        self.tablview.hidden = NO;
    }

    MLGetInviteUserApi *api = [[MLGetInviteUserApi alloc] initWithtotoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@"1" limit:@"50" type:[NSString stringWithFormat:@"%d", self.type] key:textField.text?:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"---%@",response.data);
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:response.data[@"users"]];
        [self.tablview reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}


-(void)setupUI{
    
    ML_SearchBar *search = [[ML_SearchBar alloc] initWithFrame:CGRectMake(16, ML_NavViewHeight, ML_ScreenWidth - 32, 40)];
    search.delegate = self;
    [self.view addSubview:search];
    
    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.tableFooterView = [UIView new];
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.left.right.top.mas_equalTo(ML_NavViewHeight+50);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 30;
    //设置空内容占位图
    self.tablview.ly_emptyView = emptyView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLTuijianuserlistTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
      if(cell == nil) {
          cell =[[MLTuijianuserlistTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
      }
    cell.dict = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.type = CityUITableViewCellcity;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.data[indexPath.row];
    
    [self gotoInfoVC:dict[@"userId"]];
}

@end
