//
//  MLTuijianJiangliViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLTuijianJiangliViewController.h"
#import "MLTuijianuserlistTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MGetInviteAwardApi.h"

@interface MLTuijianJiangliViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)UIView *testbgView;
@property (nonatomic,strong)UILabel *numberLabel;

@end

@implementation MLTuijianJiangliViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self giveMGetInviteAwardApi];
}

-(void)giveMGetInviteAwardApi{
    [SVProgressHUD show];
    MGetInviteAwardApi *api = [[MGetInviteAwardApi alloc]initWithtotoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@"1" limit:@"50" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"获取邀请奖励---%@",response.data);
        self.data = response.data[@"awards"];
        self.numberLabel.text = [NSString stringWithFormat:@"%@",response.data[@"inviteCredit"]];
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

    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.text = Localized(@"获得奖励", nil);
    [self setupUI];
  
}

-(void)setupUI{

    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.tableFooterView = [UIView new];
    
    self.headView = [[UIImageView alloc]init];
    self.headView.userInteractionEnabled = YES;
    self.headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 213);
    self.headView.image = kGetImage(@"bg_213");
    self.tablview.tableHeaderView = self.headView;

    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.left.right.top.mas_equalTo(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];

    [self setupUIHead];
    
}

-(void)setupUIHead{
    self.testbgView = [[UIView alloc] init];
    self.testbgView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:self.testbgView ];
    [self.testbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.headView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
        
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"被邀请人", nil);
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.headView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.testbgView.mas_centerY);
    }];


    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"";
    numberLabel.font = [UIFont systemFontOfSize:42 weight:UIFontWeightSemibold];
    numberLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.headView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_top).mas_offset(43);
        make.centerX.mas_equalTo(self.headView.mas_centerX);
    }];
    
    UILabel *numberLabelbottom = [[UILabel alloc]init];
    numberLabelbottom.text = Localized(@"积分总数", nil);
    numberLabelbottom.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    numberLabelbottom.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.headView addSubview:numberLabelbottom];
    [numberLabelbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(numberLabel.mas_bottom).mas_offset(6);
        make.centerX.mas_equalTo(self.headView.mas_centerX);
    }];

    [self.testbgView layoutIfNeeded];
    
}


- (void)viewDidLayoutSubviews {
    CGRect oldRect = _testbgView.bounds;
    oldRect.size.width = [UIScreen mainScreen].bounds.size.width;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = oldRect;
    _testbgView.layer.mask = maskLayer;
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

@end
