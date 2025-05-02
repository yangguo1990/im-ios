//
//  MLTuijiangiftViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLTuijiangiftViewController.h"
#import "ML_SettingtitleTableViewCell.h"
#import "MLTuijianbottomCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <Colours/Colours.h>
#import "SLCustomActivity.h"
#import "MLTuijianJiangliViewController.h"
#import "MLTuijianUserListViewController.h"
#import "MLGetInviteInfoApi.h"
#import "MLGetInviteUrlApi.h"
#import "MLTuijianHomeTableViewCell.h"
#import "UIViewController+MLHud.h"
#import "MLTuijianerweimaViewController.h"
#import "UIButton+ML.h"

@interface MLTuijiangiftViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
//@property (nonatomic,strong) UITableView *tabfoot;
//@property (nonatomic,strong) UITableView *tabhead;

@property (nonatomic,strong)UICollectionView *daywbtopitemview;


@property (nonatomic,strong)NSArray *ML_itemtitleArray;
@property (nonatomic,strong)NSArray *ML_itemimgArray;

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIView *footviewView;

@property (nonatomic,strong)UIView *testbgView;
@property (nonatomic,strong)NSDictionary *dataDict;
@property (nonatomic,strong)UIImageView *headbgview;

@property (nonatomic,strong)NSDictionary *dataDict2;

@property(nonatomic,strong)UILabel *pNolabel;
@property(nonatomic,strong)UILabel *inNolabel;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)UITextView *bottomTextView;

@end

@implementation MLTuijiangiftViewController


-(void)giveMLGetInviteInfoApi{
    [SVProgressHUD show];
    MLGetInviteInfoApi *api = [[MLGetInviteInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据---%@",response.data[@"invite"]);
        self.dataDict = response.data[@"invite"];
        self.pNolabel.text = [NSString stringWithFormat:@"%@%@",self.dataDict[@"inviteCount"], Localized(@"人", nil)];
        self.inNolabel.text = [NSString stringWithFormat:@"%@积分",self.dataDict[@"inviteCredit"]];
        NSArray *nmarray = self.dataDict[@"dequity"][0][@"content"];
        NSString *separator = @"\n";
        NSString *result = [nmarray componentsJoinedByString:separator];
        NSLog(@"合并后的字符串: %@", result);
        self.bottomTextView.text= result;

    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}


-(NSArray *)ML_itemtitleArray{
    if (_ML_itemtitleArray == nil) {
        if (kisCH) {
            _ML_itemtitleArray = @[/*@"微信",@"QQ",*/Localized(@"复制链接", nil),Localized(@"二维码", nil)];
        } else {
            _ML_itemtitleArray = @[@"Facebook",@"Twitter",Localized(@"复制链接", nil),Localized(@"二维码", nil)];
        }
    }
    return _ML_itemtitleArray;
}

-(NSArray *)ML_itemimgArray{
    if (_ML_itemimgArray == nil) {
        _ML_itemimgArray = @[@"icon_fuzhilianjie_44_nor-1",@"icon_erweima_44_norac"];
    }
    return _ML_itemimgArray;
}


-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIView *)testbgView {
    if (!_testbgView) {
        _testbgView = [[UIView alloc] init];
        _testbgView.backgroundColor = [UIColor whiteColor];
    }
    return _testbgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"邀请有礼", nil);
    self.ML_navView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = kGetColor(@"fe3f4e");
    [self setupUI];
    [self giveMLGetInviteInfoApi];
    
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"user/getInviteUrl"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        weakself.dataDict2 = response.data;
        
        [SVProgressHUD dismiss];
    } error:^(MLNetworkResponse *response) {
  
    } failure:^(NSError *error) {
    
    }];
}

-(void)setupUI{
    UIImageView *topIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:topIV];
    topIV.image = kGetImage(@"yaoqingTop");
    [topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(210*mHeightScale);
    }];
    
    UIImageView *topIV1 = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:topIV1];
    topIV1.image = kGetImage(@"yaoqingTop1");
    [topIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(37*mHeightScale);
        make.width.mas_equalTo(262*mWidthScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(165*mHeightScale);
    }];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectZero];
    view1.backgroundColor = UIColor.whiteColor;
    view1.layer.cornerRadius = 24*mWidthScale;
    view1.layer.masksToBounds = YES;
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(116*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(210*mHeightScale);
    }];
    
    UIImageView *view1IV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [view1 addSubview:view1IV];
    view1IV.image = kGetImage(@"yaoqingR");
    [view1IV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(160*mWidthScale);
        make.height.mas_equalTo(28*mHeightScale);
        make.centerX.mas_equalTo(view1.mas_centerX);
    }];
    
    UILabel * view1label = [[UILabel alloc]initWithFrame:CGRectZero];
    [view1 addSubview:view1label];
    view1label.text = @"我的邀请收益";
    view1label.textColor = UIColor.whiteColor;
    view1label.textAlignment = NSTextAlignmentCenter;
    view1label.font = [UIFont systemFontOfSize:16];
    [view1label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(view1IV);
    }];
    
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    pLabel.text = @"累计邀请人";
    pLabel.textColor = kGetColor(@"999999");
    pLabel.font = [UIFont systemFontOfSize:12];
    pLabel.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:pLabel];
    [pLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(view1.mas_centerX);
        make.top.mas_equalTo(view1IV.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(17*mHeightScale);
    }];
    
    UILabel *inLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    inLabel.text = @"累计收益";
    inLabel.textColor = kGetColor(@"999999");
    inLabel.font = [UIFont systemFontOfSize:12];
    inLabel.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:inLabel];
    [inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_centerX);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(view1IV.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(17*mHeightScale);
    }];
    
    self.pNolabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [view1 addSubview:self.pNolabel];
    self.pNolabel.textColor = kGetColor(@"ff4848");
    self.pNolabel.font = [UIFont boldSystemFontOfSize:36];
    self.pNolabel.textAlignment = NSTextAlignmentCenter;
    [self.pNolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(view1.mas_centerX);
        make.bottom.mas_equalTo(view1);
        make.top.mas_equalTo(pLabel.mas_bottom);
    }];
    
    self.inNolabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [view1 addSubview:self.inNolabel];
    self.inNolabel.textColor = kGetColor(@"ff4848");
    self.inNolabel.font = [UIFont boldSystemFontOfSize:36];
    self.inNolabel.textAlignment = NSTextAlignmentCenter;
    [self.inNolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_centerX);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(view1);
        make.top.mas_equalTo(inLabel.mas_bottom);
    }];
    
    UIButton *tuiguangBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tuiguangBt];
    [tuiguangBt setTitle:@"推广明细" forState:UIControlStateNormal];
    [tuiguangBt setTitleColor:kGetColor(@"ff4848") forState:UIControlStateNormal];
    tuiguangBt.titleLabel.font = [UIFont systemFontOfSize:16];
    tuiguangBt.backgroundColor = kGetColor(@"fee794");
    tuiguangBt.layer.cornerRadius = 24*mHeightScale;
    tuiguangBt.layer.masksToBounds = YES;
    [tuiguangBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(48*mHeightScale);
        make.top.mas_equalTo(view1.mas_bottom).offset(15*mHeightScale);
    }];
    
    UILabel *fenxiang = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:fenxiang];
    fenxiang.textColor = UIColor.whiteColor;
    fenxiang.font = [UIFont systemFontOfSize:16];
    fenxiang.text = @"分享到";
    [fenxiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32*mWidthScale);
        make.top.mas_equalTo(tuiguangBt.mas_bottom).offset(15*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view2];
    self.view2 = view2;
    view2.backgroundColor = UIColor.whiteColor;
    view2.layer.cornerRadius = 24*mWidthScale;
    view2.layer.masksToBounds = YES;
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(440*mHeightScale);
    }];
    
    UIButton *copyBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [view2 addSubview:copyBt];
    [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120*mWidthScale);
        make.height.mas_equalTo(70*mHeightScale);
        make.centerY.mas_equalTo(view2.mas_centerY).offset(10*mHeightScale);
        make.left.mas_equalTo(18*mWidthScale);
    }];
    [copyBt setImage:kGetImage(self.ML_itemimgArray[0]) forState:UIControlStateNormal];
    [copyBt setTitle:@"复制链接" forState:UIControlStateNormal];
    [copyBt setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    copyBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyBt addTarget:self action:@selector(copyBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [copyBt setIconInTopWithSpacing:8];
    
    UIButton *codeBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [view2 addSubview:codeBt];
    [codeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120*mWidthScale);
        make.height.mas_equalTo(70*mHeightScale);
        make.centerY.mas_equalTo(view2.mas_centerY).offset(10*mHeightScale);
        make.left.mas_equalTo(200*mWidthScale);
    }];
    codeBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeBt setImage:kGetImage(self.ML_itemimgArray[1]) forState:UIControlStateNormal];
    [codeBt setTitle:@"二维码" forState:UIControlStateNormal];
    [codeBt setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    [codeBt addTarget:self action:@selector(codeBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [codeBt setIconInTopWithSpacing:8];
    
    UILabel *tuiguang = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tuiguang];
    tuiguang.textColor = UIColor.whiteColor;
    tuiguang.font = [UIFont systemFontOfSize:16];
    tuiguang.text = @"推广规则";
    [tuiguang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32*mWidthScale);
        make.top.mas_equalTo(view2.mas_bottom).offset(15*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    UITextView * guizeTV = [[UITextView alloc]initWithFrame:CGRectZero];
    self.bottomTextView = guizeTV;
    guizeTV.layer.cornerRadius = 24*mWidthScale;
    guizeTV.layer.masksToBounds = YES;
    guizeTV.backgroundColor = UIColor.whiteColor;
    guizeTV.editable = NO;
    guizeTV.textColor = kGetColor(@"666666");
    guizeTV.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:guizeTV];
    [guizeTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(598*mHeightScale);
    }];
    
}


- (void)copyBtClick:(UIButton *)sender{
  
        MLGetInviteUrlApi *api = [[MLGetInviteUrlApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
           // NSLog(@"复制链接--%@",response.data);
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = response.data[@"inviteUrl"];
            [self showMessage:Localized(@"复制成功", nil)];
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];

    
}

- (void)codeBtClick:(UIButton *)sender{
    MLTuijianerweimaViewController *vc = [[MLTuijianerweimaViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupHeadView{

    UIImageView *bgimg = [[UIImageView alloc]init];
    bgimg.image = [UIImage imageNamed:@"libg"];
    bgimg.userInteractionEnabled = YES;
    [self.headView addSubview:bgimg];
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
  
    UIImageView *navbgimg = [[UIImageView alloc]init];
    navbgimg.hidden = YES;
    navbgimg.userInteractionEnabled = YES;
    [self.headView addSubview:navbgimg];
    [navbgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.top.mas_equalTo(bgimg.mas_top).mas_offset(54);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(114);
    }];
    

    [self.headView addSubview:self.testbgView];
    [self.testbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.headView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    //mineheadbg
    UIImageView *headbgview = [[UIImageView alloc] init];
    //headbgview.image =  [UIImage imageNamed:@"Ellipse 24"];
    [headbgview sd_setImageWithURL:kGetUrlPath([ML_AppUserInfoManager sharedManager].currentLoginUserData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
    headbgview.layer.cornerRadius = 35;
    headbgview.contentMode = UIViewContentModeScaleAspectFill;
    headbgview.layer.masksToBounds = YES;
    [self.headView addSubview:headbgview];
    self.headbgview = headbgview;
    //[self.headView layoutIfNeeded];

    [headbgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(70);
        make.centerY.mas_equalTo(self.testbgView .mas_top);
        make.centerX.mas_equalTo(self.headView.mas_centerX);
    }];
    [self.headView layoutIfNeeded];


    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.name;
    nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.headView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headbgview.mas_bottom).mas_offset(4);
        make.centerX.mas_equalTo(self.headView.mas_centerX);
    }];
    [self.testbgView layoutIfNeeded];
}

-(void)setupFootview{
    
        UICollectionViewFlowLayout *daylayout = [UICollectionViewFlowLayout new];
        daylayout.itemSize= CGSizeMake(self.view.frame.size.width/2, 109);
        //1-2、设置四周边距

        UICollectionView *daywbtopitemview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:daylayout];
        daywbtopitemview.backgroundColor = [UIColor clearColor];
        [daywbtopitemview registerClass:[MLTuijianbottomCollectionViewCell class] forCellWithReuseIdentifier:@"daywbFlow"];
        daywbtopitemview.delegate = self;
        daywbtopitemview.dataSource = self;
        daylayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        daywbtopitemview.showsVerticalScrollIndicator = NO;
        daywbtopitemview.showsHorizontalScrollIndicator = NO;
        [self.footviewView addSubview:daywbtopitemview];
        self.daywbtopitemview = daywbtopitemview;
        [daywbtopitemview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.footviewView.mas_left).mas_offset(0);
            make.right.mas_equalTo(self.footviewView.mas_right).mas_offset(0);
            make.bottom.mas_equalTo(self.footviewView.mas_bottom).mas_offset(-20);
            make.height.mas_equalTo(109);
        }];

    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = Localized(@"分享到", nil);
    indextitlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
     indextitlelabel.textAlignment = NSTextAlignmentLeft;
     [self.footviewView addSubview:indextitlelabel];
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.footviewView.mas_centerX);
        make.bottom.mas_equalTo(daywbtopitemview.mas_top).mas_offset(-20);
    }];
    
    
    
//    [self.tabhead layoutIfNeeded];
    [self.footviewView layoutIfNeeded];
    
}


- (void)viewDidLayoutSubviews {
    CGRect oldRect = _testbgView.bounds;
    oldRect.size.width = [UIScreen mainScreen].bounds.size.width;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = oldRect;
    _testbgView.layer.mask = maskLayer;
    
    self.headbgview.layer.cornerRadius = self.headbgview.frame.size.width / 2;
    self.headbgview.layer.masksToBounds = YES;
    self.headbgview.contentMode = UIViewContentModeScaleAspectFill;
    [self.headbgview layoutIfNeeded];
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        NSArray *headnmarray = self.dataDict[@"dequity"][0][@"content"];
        return headnmarray.count;
    }else{
//        NSArray *nmarray = self.dataDict[@"dequity"][1][@"content"];
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        MLTuijianHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headcell"];
        if (!cell) {
            cell = [[MLTuijianHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footcell"];
            cell.titlelabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]; // 字重
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *nmarray = self.dataDict[@"dequity"][0][@"content"];
        cell.titlelabel.text = [nmarray[indexPath.row] isKindOfClass:[NSNull class]]?@"":nmarray[indexPath.row];
        CGSize size = [cell.titlelabel.text sizeWithFont:cell.titlelabel.font maxSize:CGSizeMake(ML_ScreenWidth - 32, CGFLOAT_MAX)];
        cell.titlelabel.frame = CGRectMake(16, 10, size.width, size.height +10);
        return cell;
        
    } else if (indexPath.section == 2) {
        
        MLTuijianHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headcell"];
        if (!cell) {
            cell = [[MLTuijianHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headcell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]; // 字重
        }
        NSArray *nmarray = self.dataDict[@"dequity"][1][@"content"];
        cell.titlelabel.text = [nmarray[indexPath.row] isKindOfClass:[NSNull class]]?@"":nmarray[indexPath.row];
        CGSize size = [cell.titlelabel.text sizeWithFont:cell.titlelabel.font maxSize:CGSizeMake(ML_ScreenWidth - 32, CGFLOAT_MAX)];
        cell.titlelabel.frame = CGRectMake(16, 10, size.width, size.height +10);
        return cell;
    } else {
        
        ML_SettingtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textcell"];
        if (!cell) {
            cell = [[ML_SettingtitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textcell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]; // 字重
            cell.nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            cell.nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
            cell.subnameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            cell.subnameLabel.textColor = [UIColor colorWithHexString:@"ff4c57"];
            cell.liveV.frame = CGRectMake(20, 49, ML_ScreenWidth - 40, 1);
        }
        
        if (indexPath.row <= 2) {
            
            cell.subnameLabel.text = [NSString stringWithFormat:@"%@%@",self.dataDict[@"inviteCount"], Localized(@"人", nil)];
            cell.nameLabel.text = Localized(@"邀请的用户", nil);
            if (indexPath.row == 1) {
                
                cell.subnameLabel.text = [NSString stringWithFormat:@"%@%@",self.dataDict[@"hostCount"], Localized(@"人", nil)];
                cell.nameLabel.text = Localized(@"认证的用户", nil);
            } else if (indexPath.row == 2) {
                
                cell.subnameLabel.text = [NSString stringWithFormat:@"%@%@",self.dataDict[@"rechargeCount"], Localized(@"人", nil)];
                cell.nameLabel.text = Localized(@"充值的用户", nil);
            }
            
        }else{

            cell.nameLabel.text = Localized(@"获得奖励", nil);
//            cell.nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//            cell.nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
            
//            if ([self.dataDict[@"inviteCredit"] intValue]) {
                cell.subnameLabel.text = [NSString stringWithFormat:@"%@",self.dataDict[@"inviteCredit"]];
//            } else {
//                cell.subnameLabel.text = nil;
//            }
//            cell.subnameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
//            cell.subnameLabel.textColor = kZhuColor;

        }
            return cell;
         
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 54;
    } else{
        
        NSArray *nmarray = self.dataDict[@"dequity"][indexPath.section-1][@"content"];
        
        
        CGSize size = [nmarray[indexPath.row]?:@"" sizeWithFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] maxSize:CGSizeMake(ML_ScreenWidth - 32, CGFLOAT_MAX)];
        
        return size.height + 10;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        
        return 50;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        
        UILabel *indextitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 120, 50)];
        indextitlelabel.text = Localized(@"推广规则", nil);
        indextitlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        indextitlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
         indextitlelabel.textAlignment = NSTextAlignmentLeft;
         [headview addSubview:indextitlelabel];
        
        return headview;
    } else if (section == 2) {
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        
        UILabel *indextitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 120, 50)];
        indextitlelabel.text = Localized(@"温馨提示", nil);
        indextitlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        indextitlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
         indextitlelabel.textAlignment = NSTextAlignmentLeft;
         [headview addSubview:indextitlelabel];
        
        return headview;
    }
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tab]) {
        if (indexPath.row <= 2) {
            MLTuijianUserListViewController *vc = [[MLTuijianUserListViewController alloc]init];
            vc.type = indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            MLTuijianJiangliViewController *vc = [[MLTuijianJiangliViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark ------- UICollectionView---------
#pragma mark -点击item----collectionDelegate-----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ML_itemimgArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLTuijianbottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daywbFlow" forIndexPath:indexPath];
            //从数组里面把model取出来
            //用photo对象中的originImage属性来展示图片
    cell.nameLabel.text = self.ML_itemtitleArray[indexPath.item];
    cell.nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    cell.nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.imageView.image = kGetImage(self.ML_itemimgArray[indexPath.item]);
    return cell;
  }
   
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.item == 0){
        MLGetInviteUrlApi *api = [[MLGetInviteUrlApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
           // NSLog(@"复制链接--%@",response.data);
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = response.data[@"inviteUrl"];
            [self showMessage:Localized(@"复制成功", nil)];
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        MLTuijianerweimaViewController *vc = [[MLTuijianerweimaViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)mgAct_shareInAppWithContent:(NSString*)content image:(UIImage*)img url:(NSURL*)url
{
    
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = content;
    UIImage *imageToShare = img;
    NSURL *urlToShare = url;
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    //自定义Activity
    SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:self.dataDict2[@"title"]?:@"" withActivityImage:img withUrl:urlToShare withType:@"CustomActivity" withShareContext:activityItems];
    NSArray *activities = @[customActivit];
    
    /**
     创建分享视图控制器
     
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     
     */
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    
   
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化回调方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    }
    
    
    // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
    //关闭系统的一些activity类型
    activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    
    //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
      CGFloat minAlphaOffset = -(ML_NavViewHeight);
      CGFloat maxAlphaOffset = 300;
      CGFloat offset = scrollView.contentOffset.y;
      CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
      self.ML_navAlphaView.alpha = alpha<0.25?0:alpha;
      
    
      self.ML_titleLabel.alpha = self.ML_navAlphaView.alpha;

}

@end
