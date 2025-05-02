//
//  MLFriendTypeViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLFriendTypeViewController.h"
#import <Masonry/Masonry.h>
#import "AppCell.h"
#import "MLTabbarViewController.h"
#import "ML_ObjselectApi.h"
#import "ML_addUserTtaitApi.h"
#import "ML_RequestManager.h"


@interface MLFriendTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray *nmarray;

@property (nonatomic, strong)NSMutableArray *selectedArray;

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *datalabels;


@property (nonatomic,assign)bool isOpen;

@property (nonatomic,assign)NSInteger tegle;

@property (nonatomic,strong)UIButton *btn;

@property (nonatomic,strong) UICollectionView  *collectionView;

@end

@implementation MLFriendTypeViewController

static NSString *ident = @"cell";


-(NSMutableArray *)datalabels{
    if (_datalabels == nil) {
        _datalabels = [NSMutableArray array];
    }
    return _datalabels;
}
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
    ML_ObjselectApi *api = [[ML_ObjselectApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] gender:[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data[@"labels"]);
        //[dict setValue:@"0" forKey:@"isopen"];
        //self.data = response.data[@"datingModes"];
        [self.data removeAllObjects];
        [response.data[@"labels"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [dict setValue:@"0" forKey:@"isopen"];
            [self.data addObject:dict];
        }];
        [self.collectionView reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.isOpen = NO;
    self.tegle = 0;
    [self setupUI];
    
}

-(void)setupUI{
//    self.ML_navView.hidden = YES;
    UILabel *messagelabel = [[UILabel alloc]init];
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender isEqualToString:@"1"]) {
        messagelabel.text = Localized(@"你喜欢的女生特质是？", nil);
    }else{
        messagelabel.text = Localized(@"你喜欢的男生特质是？", nil);
    }
    messagelabel.textAlignment = NSTextAlignmentCenter;
    messagelabel.font = [UIFont systemFontOfSize:18];
    messagelabel.font = [UIFont fontWithName:@"PingFang SC" size:18.f];
    messagelabel.font = [UIFont boldSystemFontOfSize:18];
    messagelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.view addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight + SSL_StatusBarHeight);
    }];
    
    UILabel *phonetext = [[UILabel alloc]init];
    phonetext.text = Localized(@"这有助于我们为你找到最合适的人选", nil);
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
    //btn.layer.backgroundColor = kZhuColor.CGColor;
    //[btn setTitle:@"选好了" forState:UIControlStateNormal];
   
    [btn setTitle:Localized(@"至少选择4个标签", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    btn.enabled = NO;
    

    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    btn.layer.cornerRadius = 25;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    
    //1、实例化一个流水布局
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       //1-1、设置Cell大小
       flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-64)/3, 158);
       //1-2、设置四周边距
       flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
       //1-3、设置最小列之间的距离
       flowLayout.minimumLineSpacing = 10;
       //1-4、设置最小行之间的距离
       flowLayout.minimumLineSpacing = 20;
       //2、实例化创建一个 UICollectionView
       //UICollectionView必须有一个 flowLayout ，必须在实例化的时候进行设置
       UICollectionView  *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
       collectionView.backgroundColor = [UIColor whiteColor];
       //4、设置数据源代理
       collectionView.dataSource = self;
       collectionView.delegate = self;
       //添加到视图中
       [self.view addSubview:collectionView];
       //注册Cell视图
       [collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:ident];
    self.collectionView = collectionView;
        
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(phonetext.mas_bottom).mas_offset(40);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-5);
    }];
         
}

-(void)btnClick{
    NSLog(@"选好了，进入首页");

    
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"isopen"] isEqualToString:@"1"]) {
            [self.datalabels addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }
    }];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *datingModeId = [userDefault objectForKey:@"datingModeId"];
    NSString *emotioRelationId = [userDefault objectForKey:@"emotioRelationId"];
    NSString *targetAgeId = [userDefault objectForKey:@"targetAgeId"];
    
    NSString *tempString = [self.datalabels componentsJoinedByString:@","];

    
    NSDictionary *dict = @{
        @"userId":[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId,
        @"token":[ML_AppUserInfoManager sharedManager].currentLoginUserData.token,
        @"datingModeId":datingModeId,
        @"emotioRelationId":emotioRelationId,
        @"targetAgeId":targetAgeId,
        @"labelIds":tempString
    };
     [ML_RequestManager requestPath:@"trait/addUserTrait" parameters:dict doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
         NSLog(@"添加特质信息----%@",responseObject);
         
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
   [[AppDelegate shareAppDelegate] setupRootViewController:MLTabbarViewController.new];
//    UIApplication.sharedApplication.delegate.window.rootViewController = MLTabbarViewController.new;
}


//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[AppCell alloc]init];
    }
    //cell.isChecked = [self.data[indexPath.row] boolValue];
    cell.dict = self.data[indexPath.row];
    NSDictionary *dict = self.data[indexPath.row];
    if ([dict[@"isopen"] isEqualToString:@"1"]) {
        cell.isChecked = YES;
    }else{
        cell.isChecked = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexpath----%ld",(long)indexPath.row);

    NSMutableArray *nmarray = [NSMutableArray array];

    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.item) {
            if ([dict[@"isopen"] isEqualToString:@"1"]) {
                [dict setValue:@"0" forKey:@"isopen"];
                return;
           }
            [dict setValue:@"1" forKey:@"isopen"];
        }else{
        }
      }];

    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"isopen"] isEqualToString:@"1"]) {
            [nmarray addObject:dict];
        }
        if (nmarray.count >= 4) {
        [self.btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.btn.layer.backgroundColor = kZhuColor.CGColor;
            [self.btn setTitle:@"选好啦" forState:UIControlStateNormal];
        self.btn.enabled = YES;

        }else{
            [self.btn setTitle:Localized(@"至少选择4个标签", nil) forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
            self.btn.enabled = NO;
        }

    }];
       [collectionView reloadData];
}
@end
