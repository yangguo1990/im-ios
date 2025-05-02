//
//  ML_LanguageSelectViewController.m
//  miliao
//
//  Created by apple on 2022/12/8.
//

#import "ML_LanguageSelectViewController.h"
#import "ML_RequestManager.h"
#import "MLTabbarViewController.h"

@interface ML_LanguageSelectViewController ()<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *langeuageArray;
@end

@implementation ML_LanguageSelectViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加通知中心，监听语言改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:LanguageChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //移除通知中心，
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LanguageChanged object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ML_titleLabel.text = Localized(@"语言", nil);
    
    [self HY_addTableView];
    [SVProgressHUD show];
    [ML_RequestManager requestGetPath:@"base/getLanguageList" parameters:nil doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] intValue] == 0) {
            
            self.langeuageArray = responseObject[@"data"][@"languages"];
            
            [self.ML_TableView reloadData];
        } else {
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
    }];;
    
    
}

- (void)languageChanged{

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _langeuageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indetifiter = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifiter];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifiter];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 2) {
            [view removeFromSuperview];
            break;
        }
    }
    
    NSDictionary *dic = _langeuageArray[indexPath.row];
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ML_ScreenWidth-40, 12, 20, 20)];
    logoImageView.tag = 2;
    logoImageView.image = [UIImage imageNamed:@"gougou"];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bendiyuyan"];
    logoImageView.hidden = ![str isEqualToString:dic[@"code"]];
    
    [cell.contentView addSubview:logoImageView];
    cell.textLabel.text = dic[@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    NSDictionary *dic = _langeuageArray[indexPath.row];
    [SVProgressHUD showWithStatus:Localized(@"设置中", nil)];
    ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:@{@"languageCode" : dic[@"code"]?:@""} urlStr:@"user/bindLanguage"];

    [api3 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        
       [SVProgressHUD dismiss];
        
        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        [userData setLanguageCode:dic[@"code"]];
       [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
        
        
       MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
       [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
         
    } error:^(MLNetworkResponse *response) {
        tableView.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        tableView.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}


@end
