//
//  ML_SearchCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "ML_SearchCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface ML_SearchCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *videoimg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *statusImg;

@end


@implementation ML_SearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"人气推荐占位图"];
    imageView.layer.cornerRadius = 16;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView *videoimg =[[UIImageView alloc]init];
    videoimg.image = [UIImage imageNamed:@"icon_shiping_36_nor"];
    [self.contentView addSubview:videoimg];
    self.videoimg = videoimg;
    [videoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView.mas_centerY);
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.width.height.mas_equalTo(36);
    }];
            
    UIImageView *selectImg =[[UIImageView alloc]init];
    selectImg.image = [UIImage imageNamed:@"mengben2"];
    [imageView addSubview:selectImg];
    self.selectImg = selectImg;
    [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(32);
    }];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小可爱李真真真真真1真...";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"ffffff"];
    [selectImg addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectImg.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(selectImg.mas_centerY);
    }];
    
    UIImageView *statusImg =[[UIImageView alloc]init];
    //statusImg.image = [UIImage imageNamed:@"忙绿"];
    statusImg.image = kGetImage(@"label_online");
    [imageView addSubview:statusImg];
    self.statusImg = statusImg;
    [statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageView.mas_right).mas_offset(-6);
        make.top.mas_equalTo(imageView.mas_top).mas_offset(4);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
    
        
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.text = @"6999个男生";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//    titleLabel.textColor = [UIColor colorFromHexString:@"999999"];
//    [self.contentView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(1);
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//
//    }];
//
//    UIView *bgview =[[UIImageView alloc]init];
//    bgview.layer.cornerRadius = 16;
//    bgview.layer.masksToBounds = YES;
//    bgview.backgroundColor = [UIColor colorFromHexString:@"000000"];
//    bgview.alpha = 0.5;
//    [imageView addSubview:bgview];
//    self.bgview = bgview;
//    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(0);
//        make.height.mas_equalTo(104);
//    }];
//
//    UIImageView *selectImg =[[UIImageView alloc]init];
//    selectImg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
//    selectImg.layer.cornerRadius = 16;
//    selectImg.layer.masksToBounds = YES;
//    [imageView addSubview:selectImg];
//    self.selectImg = selectImg;
//    [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.width.mas_equalTo(26);
//        make.centerX.mas_equalTo(imageView.mas_centerX);
//        make.centerY.mas_equalTo(imageView.mas_centerY);
//    }];
}

-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"icon"]];
    
    NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";
    NSString *ee = [NSString stringWithFormat:@"%@%@",ss,dd];
    
    if ([dict[@"coverType"] integerValue] == 0) {
        self.videoimg.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    }else{
        
        self.videoimg.hidden = NO;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:ee] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    }
    
    if ([dict[@"name"] isEqual:[NSNull null]]) {
        self.nameLabel.text = @"这是个空数据";
    }else{
        self.nameLabel.text = dict[@"name"];
    };
    
    //在线状态，0-离线 1-勿扰 2-在聊 3-在线
    //在线 空闲 忙碌
//    if ([dict[@"online"] integerValue] == 1 || [dict[@"online"] integerValue] == 0 || [dict[@"online"] integerValue] == 2){
//        self.statusImg.image = [UIImage imageNamed:@"忙绿"];
//    }else if ([dict[@"online"] integerValue] == 3){
//        self.statusImg.image = [UIImage imageNamed:Localized(@"在线", nil)];
//    }
    
    //在线 空闲 忙碌
    if ([dict[@"online"] integerValue] == 1) {
        self.statusImg.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([dict[@"online"] integerValue] == 2){
        self.statusImg.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([dict[@"online"] integerValue] == 3){
        self.statusImg.image = kGetImage(@"label_online");
    } else {
        self.statusImg.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    
}




@end
