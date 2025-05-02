//
//  MLFriendAgeViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLFriendAgeViewController.h"
#import <Masonry/Masonry.h>
#import "MLFriendTypeViewController.h"

#import "ML_FriendAgeApi.h"


@interface MLFriendAgeViewController ()
@property (nonatomic,strong)NSMutableArray *nmArray;
@property (nonatomic,strong)NSMutableArray *data;

@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,assign)NSInteger selectindex;

@end

@implementation MLFriendAgeViewController

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
-(NSMutableArray *)nmArray{
    if (_nmArray == nil) {
        _nmArray = [NSMutableArray array];
    }
    return _nmArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self giveML_FriendModelApi];
}

-(void)giveML_FriendModelApi{
    ML_FriendAgeApi *api = [[ML_FriendAgeApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [self.nmArray removeAllObjects];
        self.data = response.data[@"traitTargetAges"];
        [response.data[@"traitTargetAges"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.nmArray addObject:dict[@"title"]];
        }];
        [self setupUI];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //[self setupUI];
    self.selectindex = 0;
}

-(void)setupUI{

    UILabel *messagelabel = [[UILabel alloc]init];
    messagelabel.text = Localized(@"你想认识的对象年龄是？", nil);
    messagelabel.textAlignment = NSTextAlignmentCenter;
    messagelabel.font = [UIFont systemFontOfSize:18];
    messagelabel.font = [UIFont fontWithName:@"PingFang SC" size:18.f];
    messagelabel.font = [UIFont boldSystemFontOfSize:18];
    messagelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.view addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight + 20);

    }];
    
    UILabel *phonetext = [[UILabel alloc]init];
    phonetext.text = Localized(@"这有助于我们为你进行精准匹配", nil);
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
      UIView *view = [UIView new];
      [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.mas_equalTo(150);
            make.top.mas_equalTo(phonetext.mas_bottom).mas_offset(44);
            make.left.mas_equalTo(27);
            make.right.mas_equalTo(-27);
            make.bottom.mas_equalTo(btn.mas_top).mas_offset(-170);
        }];

    NSMutableArray *btnAry = [NSMutableArray new];//按钮数组
        for (int i = 0; i < self.nmArray.count; i ++) {
            UIButton *agebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                agebtn.layer.backgroundColor = [UIColor colorWithRed:131/255.0 green:94/255.0 blue:255/255.0 alpha:1.0].CGColor;
                agebtn.selected = YES;
                self.selectBtn = agebtn;
            }else{
                agebtn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
                agebtn.selected = NO;
            }
            [agebtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
            [agebtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
          
            agebtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
            agebtn.layer.cornerRadius = 33;
            agebtn.tag = i;
            [agebtn setTitle:self.nmArray[i] forState:UIControlStateNormal];
            [agebtn addTarget:self action:@selector(ageClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:agebtn];
            [btnAry addObject:agebtn];
        }

    // 实现masonry垂直方向固定控件高度方法
          //垂直方向
       [btnAry mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [btnAry mas_makeConstraints:^(MASConstraintMaker *make) {
           //垂直方向可以设置水平居中
            make.right.mas_equalTo(-0);
            //make.width.equalTo(@100);
            make.left.mas_equalTo(0);
        }];
}


-(void)btnClick{
    NSLog(Localized(@"下一步", nil));

    NSDictionary *dict = self.data[self.selectindex];
    NSUserDefaults *userdeful = [NSUserDefaults standardUserDefaults];
    [userdeful setObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"targetAgeId"];
    [userdeful synchronize];
    MLFriendTypeViewController *ageVc = [[MLFriendTypeViewController alloc]init];
    [self.navigationController pushViewController:ageVc animated:YES];
}


-(void)ageClick:(UIButton *)btnClick{
    
    NSLog(@"%ld",(long)btnClick.tag);
    self.selectindex = btnClick.tag;
    self.selectBtn.selected = NO;
    btnClick.selected = YES;
    //这里为设置按钮的背景颜色

    if (self.selectBtn == btnClick) {
    }else{
        btnClick.layer.backgroundColor = [UIColor colorWithRed:131/255.0 green:94/255.0 blue:255/255.0 alpha:1.0].CGColor;
          self.selectBtn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    }
    self.selectBtn = btnClick;
}


@end
