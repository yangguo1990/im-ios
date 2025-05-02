//
//  ML_BlackViewController.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_BlackViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_FocusBottomTableViewCell.h"
#import "ML_CancelBlackApi.h"
#import "ML_GetBlackListApi.h"
#import <SDWebImage/SDWebImage.h>
@interface ML_BlackViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIView *ML_headview;
@property (nonatomic ,assign) BOOL isInsertEdit;
@property (nonatomic ,strong) UIButton *btn;

@end

@implementation ML_BlackViewController

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"黑名单", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self giveML_GetBlackListApi];
}

-(void)giveML_GetBlackListApi{
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
          //  NSString *token = [userDefault objectForKey:@"token"];
    
    [SVProgressHUD show];
        ML_GetBlackListApi *api = [[ML_GetBlackListApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        self.data = response.data[@"users"];
        [self.tableView reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
     
}

-(void)giveML_CancelBlackApitoUserId:(NSString *)userId{
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
       // NSString *token = [userDefault objectForKey:@"token"];
    ML_CancelBlackApi *api = [[ML_CancelBlackApi alloc]initWithblock:@"0" extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token toUserId:userId];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"取消拉黑---%@",response.data);
        [self.tableView reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

- (NSString *)jsonStringForDictionary{
        UIDevice *device = [[UIDevice alloc] init];
        NSString *name = [self getCurrentDeviceModel];       //获取设备所有者的名称
        NSString *systemName = device.systemName;   //获取当前运行的系统
        NSString *systemVersion = device.systemVersion;//获取当前系统的版本
        NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSString *ppversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dicJson= @{@"sysType":systemName,
                                    @"sysVersion":systemVersion,
                                    @"appVersion":ppversion,
                                    @"phoneType":name,
                                    @"ip":@"",
                                    @"imei":udid,
                                    @"location":@"",
                                    @"platform":@""};
    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}

-(void)setupUI{
    _isInsertEdit = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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

- (UIButton *)btn{
    if (!_btn) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 50, 44);
        [_btn setTitle:@"解除" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(onClicksender:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
    if (!cell) {
        
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,self.data[indexPath.row][@"icon"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
          CGSize itemSize = CGSizeMake(48, 48);
          UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
          CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
          [cell.imageView.image drawInRect:imageRect];
          cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();
    cell.textLabel.text = self.data[indexPath.row][@"name"];
        return cell;
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)onClicksender:(UIButton *)sender{
        sender.selected = !sender.selected;
        if (sender.selected) {
            [_btn setTitle:Localized(@"完成", nil) forState:UIControlStateNormal];
            _isInsertEdit = YES;
            [_tableView setEditing:YES animated:YES];
        }else{
            [_btn setTitle:@"解除" forState:UIControlStateNormal];
            _isInsertEdit = NO;
            [_tableView setEditing:NO animated:YES];
        }
    }

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isInsertEdit) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *userid = self.data[indexPath.row][@"id"];
        [self.data removeObjectAtIndex:indexPath.row];
        [self giveML_CancelBlackApitoUserId:userid];
         [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

    }
}


@end
