//
//  ML_HomeCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/3/23.
//

#import "ML_HomeCollectionViewCell.h"
#import "ML_sayHelloApi.h"

@implementation ML_HomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:backView];
    backView.layer.cornerRadius = 18*mWidthScale;
    backView.layer.masksToBounds = YES;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [backView addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(168*mHeightScale);
    }];
    topImage.userInteractionEnabled = YES;
    self.isliveing = topImage;
    UIImageView *levelImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [topImage addSubview:levelImage];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12*mWidthScale);
        make.top.mas_equalTo(18*mHeightScale);
        make.width.mas_equalTo(56*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
//    levelImage.backgroundColor = UIColor.systemPinkColor;
    self.isking = levelImage;
    
    UIImageView * onlineImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [topImage addSubview:onlineImage];
    [onlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18*mHeightScale);
        make.right.mas_equalTo(-10*mWidthScale);
        make.width.mas_equalTo(42*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    self.isonline = onlineImage;
    
    UIImageView *shipinIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [topImage addSubview:shipinIV];
    [shipinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(74*mWidthScale);
        make.height.mas_equalTo(26*mHeightScale);
    }];
    self.videoimg = shipinIV;
    shipinIV.image = kGetImage(@"shipinB");
    UIImageView *shipinB1 = [[UIImageView alloc]initWithFrame:CGRectZero];
    shipinB1.image = kGetImage(@"shipinB1");
    [shipinIV addSubview:shipinB1];
    [shipinB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12*mWidthScale);
        make.centerY.mas_equalTo(shipinB1.mas_centerY);
        make.left.mas_equalTo(4*mWidthScale);
    }];
    UIImageView *shipinB2 = [[UIImageView alloc]initWithFrame:CGRectZero];
    shipinB2.image = kGetImage(@"shipinB2");
    [shipinIV addSubview:shipinB2];
    [shipinB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12*mWidthScale);
        make.width.mas_equalTo(38*mWidthScale);
        make.centerY.mas_equalTo(shipinB1.mas_centerY);
        make.left.mas_equalTo(shipinB1.mas_right).offset(5);
    }];
    
    UIButton *helloBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [topImage addSubview:helloBt];
    [helloBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-10*mWidthScale);
        make.width.height.mas_equalTo(32*mWidthScale);
    }];
    self.helloBt = helloBt;
    [self.helloBt setBackgroundImage:kGetImage(@"helloBG") forState:UIControlStateNormal];
    [self.helloBt addTarget:self action:@selector(hello:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *videoBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [topImage addSubview:videoBt];
    [videoBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(helloBt.mas_centerY);
        make.right.mas_equalTo(helloBt.mas_left).offset(-10*mWidthScale);
        make.width.height.mas_equalTo(32*mWidthScale);
    }];
    [videoBt setBackgroundImage:kGetImage(@"videoBt") forState:UIControlStateNormal];
    [videoBt addTarget:self action:@selector(videoBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12*mWidthScale);
        make.top.mas_equalTo(topImage.mas_bottom).offset(12*mHeightScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    self.nickName = nameLabel;
    
    UIImageView *sexIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [backView addSubview:sexIV];
    [sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(12*mWidthScale);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.width.height.mas_equalTo(16*mWidthScale);
    }];
    self.sexIV = sexIV;
    
    UILabel *ageAddlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [backView addSubview:ageAddlabel];
    [ageAddlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    ageAddlabel.textColor = kGetColor(@"aaa6ae");
    ageAddlabel.font = [UIFont systemFontOfSize:12];
    self.ageBt = ageAddlabel;
    
    UIImageView *realIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [backView addSubview:realIV];
    [realIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ageAddlabel.mas_left);
        make.top.mas_equalTo(ageAddlabel.mas_bottom).offset(5*mHeightScale);
        make.width.mas_equalTo(42*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    realIV.image = kGetImage(@"isreal");
    self.isreal = realIV;
    self.isreal.hidden = YES;
    UIImageView *shiIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [backView addSubview:shiIV];
    [shiIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(realIV.mas_right).offset(10*mWidthScale);
        make.top.mas_equalTo(ageAddlabel.mas_bottom).offset(5*mHeightScale);
        make.width.mas_equalTo(42*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    shiIV.image = kGetImage(@"shiming");
    shiIV.hidden = YES;
}

- (void)videoBtClick:(UIButton*)sender{
    [self gotoCallVCWithUserId:self.isId?self.dic[@"id"]:self.dic[@"userId"] isCalled:NO];
}

- (void)setDic:(NSDictionary *)dic{
    _dic=dic;
    self.isking.hidden = NO;
    if([dic[@"host"]intValue] == 1){
        if ([dic[@"title"] integerValue] == 1){
            self.isking.image = [UIImage imageNamed:@"wangpaibo"];
        }else if ([dic[@"title"] integerValue] == 2){
            self.isking.image = [UIImage imageNamed:@"zuijiaxx"];
        }else{
            self.isking.hidden = YES;
        }
    }else{
        NSInteger level = [dic[@"identity"] integerValue];
        
        if (level == 0) {
            self.isking.hidden = YES;
        }else{
            self.isking.hidden = NO;
            switch (level) {
                case 10:
                    self.isking.image = kGetImage(@"baiyingIcon");
                    break;
                case 20:
                    self.isking.image = kGetImage(@"huangjinIcon");
                    break;
                case 30:
                    self.isking.image = kGetImage(@"zuanshiIcon");
                    break;
                default:
                    break;
            }
        }
        
    }
    
    if ([[dic objectForKey: @"coverType"]integerValue] == 0) {
        self.videoimg.hidden = YES;

        [self.isliveing sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        

    }else{

        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";

        NSString *icon = [NSString stringWithFormat:@"%@%@", [dic objectForKey: @"cover"], dd];
        NSURL *ee = kGetUrlPath(icon);
        
        self.videoimg.hidden = NO;
        if ([[dic objectForKey: @"cover"] containsString:@".gif"]) {
            [self.isliveing sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        } else {
            [self.isliveing sd_setImageWithURL:ee placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        }
    }
    
    if ([[dic objectForKey: @"name"] isEqual:[NSNull null]]) {
        self.nickName.text = @"";
    }else{
        self.nickName.text = [dic objectForKey: @"name"];
    };
    
    if([dic[@"call"]intValue] == 0){
        self.helloBt.hidden = NO;
    }else{
        self.helloBt.hidden = YES;
    }
    
//    if([dic[@"host"]intValue] == 1){
//        self.isreal.hidden  = NO;
//    }else{
//        self.isreal.hidden  = YES;
//    }
    
    //在线状态，0-离线 1-勿扰 2-在聊 3-在线
    //在线 空闲 忙碌
    if ([[dic objectForKey: @"online"]integerValue]  == 1) {
        self.isonline.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([[dic objectForKey: @"online"]integerValue]  == 2){
        self.isonline.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([[dic objectForKey: @"online"]integerValue]  == 3){
        self.isonline.image = kGetImage(@"label_online");
    } else {
        self.isonline.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    if([[dic objectForKey: @"gender"]integerValue] == 1){
        //男
        self.sexIV.image = kGetImage(@"male");

    }else{
        //女
        self.sexIV.image = kGetImage(@"female");

    }
    self.signLabel.text=[dic objectForKey: @"persionSign"];
    [self.headIV sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    NSString *age = [[dic objectForKey:@"age"]stringValue];
    NSString *city = [dic objectForKey:@"city"];
    int distance = [dic[@"distance"]intValue];
    if ([dic objectForKey:@"city"]) {
        self.ageBt.text = [NSString stringWithFormat:@"%@|%.2fkm",city,(distance/1000.0)];
    }else{
        self.ageBt.text = @"";
    }
    
}


- (void)hello:(UIButton*)sender{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc] initWithtoken:token toUserId:self.isId?self.dic[@"id"]:self.dic[@"userId"] extra:[self jsonStringForDictionary]];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        kplaceToast(Localized(@"打招呼成功,可以给好友私信啦", nil));
        [SVProgressHUD dismiss];
        [weakself.dic setValue:@"1" forKey:@"call"];
        weakself.helloBt.hidden = YES;
//        btn.selected = !btn.selected;
//        [btn removeFromSuperview];
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}




@end
