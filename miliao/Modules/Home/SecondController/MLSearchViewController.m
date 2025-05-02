//
//  MLSearchViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLSearchViewController.h"
#import "ML_SearchBar.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_searchApi.h"
#import "ML_SearchCollectionViewCell.h"
#import "ML_HostVideoViewController.h"
#import "ML_HostdetailsViewController.h"
#import "ML_FocusBottomTableViewCell.h"
#import "MLHomeSearchTableViewCell.h"
#import "MLFocusApi.h"
#import "ML_getTypeHostsApi.h"
#import "ML_NTableViewCell.h"

@interface MLSearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,TermCellDelegate>
//@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_searchArray;
@property (nonatomic,strong)NSMutableArray *ML_dataArray;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *keyword;

@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)UIView *ML_headVeiw;
@property (nonatomic,assign)BOOL isofocus;
@property (nonatomic,strong)UITableView *homeTableview;
@property (nonatomic,strong)UIView *homeTabHead;
@end

@implementation MLSearchViewController


static NSString *ident = @"cell";

-(NSMutableArray *)ML_searchArray{
    if (_ML_searchArray == nil) {
        _ML_searchArray = [NSMutableArray array];
    }
    return _ML_searchArray;
}

-(NSMutableArray *)ML_dataArray{
    if (_ML_dataArray == nil) {
        _ML_dataArray = [NSMutableArray array];
    }
    return _ML_dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isYao) {
        
        [self giveML_searchApi];
        [self bottomgiveML_focusApi];
    }
    self.ML_navView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

-(void)bottomgiveML_focusApi{
    [self.ML_dataArray removeAllObjects];
    [SVProgressHUD show];
    kSelf;
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"6" page:@"" limit:@"6" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [self.ML_dataArray addObjectsFromArray:response.data[@"hosts"]];
//        [self.ML_homeCollectionView reloadData];
        
        [SVProgressHUD dismiss];
        [weakself.homeTableview reloadData];
    } error:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)giveML_searchApi{
    
    
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_searchApi *api = [[ML_searchApi alloc]initWithkeyword:self.keyword type:self.type?:@"0" page:@"1" limit:@"50" extra:[self jsonStringForDictionary] token:token];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            [self.ML_searchArray removeAllObjects];
            //[self.ML_searchArray removeAllObjects];
            self.ML_searchArray = response.data[@"users"];
            
            [self.tablview reloadData];
            //[self.ML_homeCollectionView reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ML_navView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self ML_setupUI];
    //self.page = @"1";
    self.keyword = @"";
    self.isofocus = NO;
    
}


-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)ML_setupUI{
    [self ML_setupHeadUI];
    UIImageView *topBC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 160*mHeightScale)];
    topBC.image = kGetImage(@"bg_top");
    [self.view addSubview:topBC];
    
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [cancelbtn setBackgroundImage:kGetImage(@"kaitongBG") forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24*mWidthScale);
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(54*mHeightScale);
        make.height.mas_equalTo(24*mWidthScale);
    }];
        
    ML_SearchBar *search = [[ML_SearchBar alloc]init];
    search.delegate = self;
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(56*mWidthScale);
        make.height.mas_equalTo(32*mHeightScale);
        make.centerY.mas_equalTo(cancelbtn.mas_centerY);
        make.right.mas_equalTo(-16*mWidthScale);
    }];
    

    self.homeTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.homeTableview.delegate=self;
    self.homeTableview.dataSource=self;
    self.homeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.homeTableview registerClass:[ML_NTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.homeTableview];
    [self.homeTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(search.mas_bottom).mas_offset(10*mHeightScale);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    self.homeTableview.layer.cornerRadius = 16*mWidthScale;
    
    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.hidden = YES;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tablview registerClass:[ML_NTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tablview.tableFooterView = [UIView new];
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(0);
    make.top.mas_equalTo(search.mas_bottom).mas_offset(10*mHeightScale);
    make.bottom.mas_equalTo(self.view).mas_offset(0);
     }];
    self.tablview.layer.cornerRadius = 16*mWidthScale;
    
}

-(void)ML_setupHeadUI{
    self.ML_headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 32*mHeightScale)];
    UIImageView *hotyouImg =[[UIImageView alloc]init];
    hotyouImg.image = [UIImage imageNamed:@"title_recommended_for_you"];
    [self.ML_headVeiw addSubview:hotyouImg];
    [hotyouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headVeiw.mas_left).mas_offset(16*mWidthScale);
        make.top.mas_equalTo(self.ML_headVeiw.mas_top).mas_offset(14*mHeightScale);
        make.height.mas_equalTo(16*mHeightScale);
        make.width.mas_equalTo(88*mWidthScale);
    }];

    UIButton *huanbtn = [self createButtonWithTitle:Localized(@"换一批", nil)];
//    UIButton *huanbtn = [[UIButton alloc] init];
    [self.ML_headVeiw addSubview:huanbtn];
    [huanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(54*mWidthScale);
        make.right.mas_equalTo(self.ML_headVeiw.mas_right).mas_offset(-16*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
        make.centerY.mas_equalTo(hotyouImg.mas_centerY);
    }];

}


#pragma mark ------换一批----------
-(void)newButtonAction{
    NSLog(Localized(@"换一批", nil));
    [self bottomgiveML_focusApi];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        self.homeTableview.hidden = NO;
        self.tablview.hidden = YES;
    }else{
        self.homeTableview.hidden = YES;
        self.tablview.hidden = NO;
    }
    self.keyword = textField.text;
    
    [self giveML_searchApi];
    
}



- (UIButton *)createButtonWithTitle:(NSString *)title{
    UIButton * button = [[UIButton alloc] init];
    [button setBackgroundImage:kGetImage(@"button_for_batch_24") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark -----tableView-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.tablview]){
        //搜索
        return self.ML_searchArray.count;
    }else{
        //非搜索
        return self.ML_dataArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ML_NTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.issearch=YES;
    if([tableView isEqual:self.tablview]){
        cell.dic = self.ML_searchArray[indexPath.row];
        cell.isguanzhu=NO;
       
    }else{
        cell.dic = self.ML_dataArray[indexPath.row];
        cell.isguanzhu = YES;
    }
    
    
    cell.tag = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 102*mHeightScale;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *currentDic;
    if([tableView isEqual:self.tablview]){
        currentDic = self.ML_searchArray[indexPath.row];
    }else{
        currentDic = self.ML_dataArray[indexPath.row];
    }
    
    if ([currentDic[@"coverType"] integerValue] == 0) {
        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
        vc.dict = currentDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
        vc.dict =currentDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.homeTableview]){
        return self.ML_headVeiw;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.homeTableview]){
        return 32*mHeightScale;
    }else{
        return 0;
    }
   
}

- (void)choseTerm:(UIButton *)button index:(NSInteger)index{
    NSLog(@"点击第几个cell%ld",index);
    button.tag = index;
    [self giveMLFocusApi:[self.ML_dataArray[index][@"focus"] boolValue] toUserId:self.ML_dataArray[index][@"userId"] btn:button];
}
#pragma mark -----关注------
-(void)giveMLFocusApi:(BOOL)indexstr toUserId:(NSString *)touserId btn:(UIButton *)button{
    MLFocusApi *api = [[MLFocusApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:touserId type:[NSString stringWithFormat:@"%d", !indexstr]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"关注接口----%@",response.data);
        //[self.tablview reloadData];
        if (indexstr) {
            
                button.backgroundColor = kZhuColor;
                [button setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
                
        } else {
                button.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
                [button setTitle:Localized(@"已关注", nil) forState:UIControlStateNormal];
        }
        
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.ML_dataArray[button.tag]];
        [muDic setObject:@(!indexstr) forKey:@"focus"];
        [self.ML_dataArray replaceObjectAtIndex:button.tag withObject:muDic];
        
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:button.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [self.tablview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}


@end
