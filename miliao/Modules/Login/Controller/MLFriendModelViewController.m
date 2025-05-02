//
//  MLFriendModelViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLFriendModelViewController.h"
#import <Masonry/Masonry.h>
#import "FriendTableViewCell.h"
#import "MLFriendViewController.h"
#import "ML_FriendModelApi.h"
#import <SDWebImage/SDWebImage.h>
#import "UIViewController+MLHud.h"
#import "YNNavigationController.h"


@interface MLFriendModelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;

@end

@implementation MLFriendModelViewController

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self giveML_FriendModelApi];
}





-(void)giveML_FriendModelApi{
    ML_FriendModelApi *api = [[ML_FriendModelApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data[@"datingModes"]);
        //[dict setValue:@"0" forKey:@"isopen"];
        //self.data = response.data[@"datingModes"];
        [self.data removeAllObjects];
        [response.data[@"datingModes"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [dict setValue:@"1" forKey:@"isopen"];
            }else{
                [dict setValue:@"0" forKey:@"isopen"];
            }
            [self.data addObject:dict];
        }];
        [self.tab reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.yn_banRightSliderGesture = YES;
    [self setupUI];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(clickback)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
-(void)clickback{
    [self showMessage:@"无法返回,请完成下一步信息"];
}


-(void)setupUI{
    
   // self.ML_navView.hidden = YES;
    UILabel *messagelabel = [[UILabel alloc]init];
    messagelabel.text = Localized(@"你想要的交友模式是？", nil);
    messagelabel.textAlignment = NSTextAlignmentCenter;
    messagelabel.font = [UIFont systemFontOfSize:18];
    messagelabel.font = [UIFont fontWithName:@"PingFang SC" size:18.f];
    messagelabel.font = [UIFont boldSystemFontOfSize:18];
    messagelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.view addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight + 10);
    }];
    
    UILabel *phonetext = [[UILabel alloc]init];
    phonetext.text = Localized(@"我们会帮你找到符合你期望的人", nil);
    phonetext.textAlignment = NSTextAlignmentCenter;
    phonetext.font = [UIFont systemFontOfSize:14];
    phonetext.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    phonetext.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:phonetext];
    [phonetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(messagelabel.mas_bottom).mas_offset(12);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.backgroundColor = kZhuColor.CGColor;
    btn.layer.cornerRadius = 25;
    [btn setTitle:Localized(@"下一步", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
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
        make.top.mas_equalTo(phonetext.mas_bottom).mas_offset(21);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-20);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
            cell =[[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        }
    cell.dict = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.isChecked = self.data[indexPath.row];
    //cell.isChecked = [self.data[indexPath.row] boolValue];
    NSDictionary *dict = self.data[indexPath.row];
    if ([dict[@"isopen"] isEqualToString:@"1"]) {
        cell.isChecked = YES;
    }else{
        cell.isChecked = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
              //self.data[indexPath.row] = @(YES);
              [dict setValue:@"1" forKey:@"isopen"];
            //[self.data removeObjectAtIndex:idx];
            //[self.data  insertObject:dict atIndex:idx];
        }else{
             // self.data[idx] = @(NO);
              [dict setValue:@"0" forKey:@"isopen"];
            //[self.data removeObjectAtIndex:idx];
            //[self.data  insertObject:dict atIndex:idx];
          }
        //[self.data insertObject:dict atIndex:idx];
      }];

       [tableView reloadData];
  }

-(void)btnClick{
    NSLog(Localized(@"下一步", nil));
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"isopen"] isEqualToString:@"1"]) {
            NSUserDefaults *userdeful = [NSUserDefaults standardUserDefaults];
            [userdeful setObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"datingModeId"];
            [userdeful synchronize];
        }
    }];
    MLFriendViewController *vc = [[MLFriendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


@end
