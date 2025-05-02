//
//  MLZhaohuSettingViewController.m
//  miliao
//
//  Created by apple on 2022/10/12.
//

#import "MLZhaohuSettingViewController.h"
#import <Masonry/Masonry.h>
#import "MLMineZhaohuSetTableViewCell.h"
#import "MLFriendViewController.h"
#import "ML_FriendModelApi.h"
#import <SDWebImage/SDWebImage.h>
#import "UIViewController+MLHud.h"
#import "YNNavigationController.h"
#import <Colours/Colours.h>
#import "UIViewController+MLHud.h"


#import "MLZhaohuListApi.h"
#import "MLAddZhaoHuApi.h"
#import "MLDeletZhaoApi.h"
#import "MLZhidingZhaohuApi.h"
#import "MLEditZhaohuApi.h"

#import "MLSelectFirstHostCallCententApi.h"
#import "MLDeletZhaohuView.h"
#import "MLEditZhaoHuView.h"
#import "MLAddZhaoHuView.h"
@interface MLZhaohuSettingViewController ()<UITableViewDelegate,UITableViewDataSource,TermCellDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong)UIButton *addbtn;
@property (nonatomic,strong)MLDeletZhaohuView *deletZhaohuView;

@property (nonatomic,strong)MLEditZhaoHuView *editZhaohuView;
@property (nonatomic,strong)MLAddZhaoHuView *addZhaohuView;
@property (nonatomic,strong)UIView *NmaskView;
@property (nonatomic,copy)NSString *contentStr;

@end

@implementation MLZhaohuSettingViewController

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}

#pragma mark -- 获取招呼列表------
-(void)giveMLZhaohuListApi{
    MLZhaohuListApi *api = [[MLZhaohuListApi alloc]initWithstatus:@"0" limit:@"10" page:@"1" token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"招呼设置列表----%@",response.data);
        self.data  = response.data[@"callContents"];
        
        [self.addbtn setTitle:[NSString stringWithFormat:@"%@(%lu/10)",Localized(@"增加招呼语", nil), (unsigned long)self.data.count] forState:UIControlStateNormal];
        [self.tab reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"招呼设置", nil);
    self.ML_navView.backgroundColor = UIColor.clearColor;
    UIImageView *topIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:topIV];
    topIV.image = kGetImage(@"bg_top");
    [topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(88*mHeightScale);
    }];
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self giveMLZhaohuListApi];
}

-(void)setupUI{
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbtn setTitle:[NSString stringWithFormat:@"%@(1/10)",Localized(@"增加招呼语", nil)] forState:UIControlStateNormal];
    [addbtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addbtn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    addbtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    [addbtn setImage:[UIImage imageNamed:@"icon_xinzeng_39_nor"] forState:UIControlStateNormal];
//    [addbtn setImage:[UIImage imageNamed:@"icon_xinzeng_39_nor"] forState:UIControlStateSelected];
    [addbtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbtn];
    self.addbtn = addbtn;
    [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16*mWidthScale);
        make.left.mas_equalTo(16*mWidthScale);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarSafeBottomMargin);
        make.height.mas_equalTo(48*mHeightScale);
    }];

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
        make.bottom.mas_equalTo(addbtn.mas_top).mas_offset(0);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MLMineZhaohuSetTableViewCell *cell = [[MLMineZhaohuSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    MLMineZhaohuSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MLMineZhaohuSetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dict = self.data[indexPath.row];
    cell.tag = indexPath.row;
    cell.conStr = self.data[indexPath.row][@"content"];
    cell.label.text = [NSString stringWithFormat:@"文案 %ld",indexPath.row];
//    cell.nameLabel.text = self.data[indexPath.row][@"content"];
    if (indexPath.row == 0) {
        [cell.zhidingbtn setTitleColor:kZhuColor forState:UIControlStateNormal];
        [cell.zhidingbtn setImage:[UIImage imageNamed:@"icon-yizhiding_18_CCC_sel"] forState:UIControlStateNormal];
    } else {
        
        [cell.zhidingbtn setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
        [cell.zhidingbtn setImage:[UIImage imageNamed:@"icon-zhiding_18_666_nor"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMineZhaohuSetTableViewCell * cell = (MLMineZhaohuSetTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *conStr = self.data[indexPath.row][@"content"];
    CGSize size = [conStr sizeWithFont:cell.nameLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 32, 100)];
    
    
    return 140*mHeightScale;
}

-(void)addClick{
    if (self.data.count == 10) {
        [self showMessage:@"最多添加10条招呼语哦~"];
        return;
    }
    NSLog(@"添加");
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    self.addZhaohuView = [MLAddZhaoHuView alterVietextviewStrblock:^(NSString * _Nonnull textViewStr) {
        self.contentStr = textViewStr;
    } sureBtClcik:^{
        [self.NmaskView removeFromSuperview];

        if (self.contentStr == nil || self.contentStr == NULL || [self.contentStr isEqualToString:@"请输入你的常用招呼语"]) {
            [self showMessage:@"内容为空,不能添加哦"];
            return;
        }
        MLAddZhaoHuApi *api = [[MLAddZhaoHuApi alloc]initWithcontent:self.contentStr token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"添加招呼----%@",response.data);
            [self showMessage:Localized(@"招呼语已提交审核", nil)];
            [self giveMLZhaohuListApi];
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
            }];
    } cancelClick:^{
           [self.NmaskView removeFromSuperview];
    }];
     [self.NmaskView addSubview:self.addZhaohuView];
     [window addSubview:self.NmaskView];
}

#pragma mark - TermCellDelegate
- (void)choseTerm:(UIButton *)button index:(NSInteger)index{
    NSLog(@"TermCellDelegate-第几个cell--%ld---%ld",index,(long)button.tag);

    if (button.tag == 3000) {
        [self setML_SHowViewindex:index];
    } else if (button.tag == 1000){
        MLZhidingZhaohuApi *zhidingapi = [[MLZhidingZhaohuApi alloc]initWithcontentId:self.data[index][@"id"] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        kSelf;
        [zhidingapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"置顶招呼----%@",response.data);
//            [self giveMLZhaohuListApi];
            NSDictionary *dic = weakself.data[index];
            [weakself.data removeObjectAtIndex:index];
            [weakself.data insertObject:dic atIndex:0];
            [weakself.tab reloadData];
            
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
    }else{
        //编辑------
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        NSString *sssss = self.data[index][@"content"];
        self.editZhaohuView = [MLEditZhaoHuView alterVietextviewStrblock:^(NSString * _Nonnull textViewStr) {
            self.contentStr = textViewStr;
        }lengthstr:[NSString stringWithFormat:@"%lu/",(unsigned long)sssss.length] textView:self.data[index][@"content"] sureBtClcik:^{
            [self.NmaskView removeFromSuperview];
            if (self.contentStr == nil || self.contentStr == NULL) {
                return;
            }
            MLEditZhaohuApi *api = [[MLEditZhaohuApi alloc]initWithcontent:self.contentStr contentId:self.data[index][@"id"] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                NSLog(@"编辑资料--%@",response.data);
                [self showMessage:Localized(@"招呼语已提交审核", nil)];
                [self giveMLZhaohuListApi];
                        } error:^(MLNetworkResponse *response) {
                        } failure:^(NSError *error) {
                        }];
         
        } cancelClick:^{
            [self.NmaskView removeFromSuperview];
        }];
         [self.NmaskView addSubview:self.editZhaohuView];
         [window addSubview:self.NmaskView];
    }
}

#pragma mark --- 删除--------
-(void)setML_SHowViewindex:(NSInteger)index{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    self.deletZhaohuView = [MLDeletZhaohuView alterViewWithTitle:@"" content:@"" sure:@""
                    address:@"" name:@"" phone:@"" timer:@"" sureBtClcik:^{
        NSLog(@"打电话....");
        [self.NmaskView removeFromSuperview];
        MLDeletZhaoApi *deapi = [[MLDeletZhaoApi alloc]initWithids:self.data[index][@"id"] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [deapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"删除招呼----%@",response.data);
            [self giveMLZhaohuListApi];
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
            }];
      } cancelClick:^{
          NSLog(Localized(@"取消", nil));
          [self.NmaskView removeFromSuperview];
    }];
     [self.NmaskView addSubview:self.deletZhaohuView];
     [window addSubview:self.NmaskView];
    
    
}





@end
