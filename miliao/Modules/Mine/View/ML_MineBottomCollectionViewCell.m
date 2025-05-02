//
//  ML_MineBottomCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/3/26.
//

#import "ML_MineBottomCollectionViewCell.h"
#import "ML_SetDNDApi.h"
@implementation ML_MineBottomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.contentView.backgroundColor = kGetColor(@"f8f8f8");
    self.contentView.layer.cornerRadius = 12*mWidthScale;
    self.contentView.layer.masksToBounds = YES;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectZero];
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.cellIcon = icon;
    self.nameLabel = nameLabel;
    [self.contentView addSubview:icon];
    [self.contentView addSubview:nameLabel];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24*mWidthScale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(24*mHeightScale);
    }];
    
    nameLabel.textColor = kGetColor(@"a9a9ab");
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon.mas_centerY);
        make.height.mas_equalTo(18*mHeightScale);
        make.left.mas_equalTo(icon.mas_right).offset(20);
    }];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24*mWidthScale);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.right.mas_equalTo(-20*mWidthScale);
    }];
    iv.image = kGetImage(@"rightArrow");
    self.rightArrow = iv;
    
    
    UIButton *setnetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setnetbtn setImage:[UIImage imageNamed:@"icon_weixuanzhong_nor"] forState:UIControlStateNormal];
    [setnetbtn setImage:[UIImage imageNamed:@"icon_xuanzhong_sel"] forState:UIControlStateSelected];
    [setnetbtn addTarget:self action:@selector(swicthClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:setnetbtn];
    self.setnetbtn = setnetbtn;
    [setnetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(54);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    if ([currentData.dnd intValue] == 0) {
        self.setnetbtn.selected = NO;
    }else{
        self.setnetbtn.selected = YES;
    }
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightArrow.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(84);
    }];
    
    
}


- (void)swicthClick:(UIButton*)sender{
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    ML_SetDNDApi *api = [[ML_SetDNDApi alloc]initWithdnd:@(![currentData.dnd boolValue]) extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        UserInfoData *userInfoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        if ([userInfoData.dnd isEqualToString:@"1"]) {
            userInfoData.dnd = @"0";
            weakself.setnetbtn.selected = NO;
        }else{
            userInfoData.dnd = @"1";
            weakself.setnetbtn.selected = YES;
        }
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userInfoData;
       
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}
@end
