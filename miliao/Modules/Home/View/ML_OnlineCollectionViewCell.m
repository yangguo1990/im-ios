//
//  ML_OnlineCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/1.
//

#import "ML_OnlineCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface ML_OnlineCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *videoimg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *statusImg;

@property (nonatomic,strong)UIImageView *onlineimg;
@end


@implementation ML_OnlineCollectionViewCell

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
    
    UIImageView *onlineimg = [[UIImageView alloc]init];
    [imageView addSubview:onlineimg];
    self.onlineimg = onlineimg;
    [onlineimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageView.mas_right).mas_offset(-6);
        make.top.mas_equalTo(imageView.mas_top).mas_offset(4);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
    
//    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
//        UIImageView *statusImg =[[UIImageView alloc]init];
//        [imageView addSubview:statusImg];
//        self.statusImg = statusImg;
//        [statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(onlineimg.mas_centerY);
//            make.right.mas_equalTo(onlineimg.mas_left).mas_offset(-4);
//            make.height.mas_equalTo(28);
//            make.width.mas_equalTo(28);
//        }];
//
//    }
}

-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@", basess, dict[@"cover"]];
    
    NSString *ee = [NSString stringWithFormat:@"%@",ss];
    
    if ([dict[@"coverType"] integerValue] == 0) {
        self.videoimg.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    }else{
        
        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";
        ee = [NSString stringWithFormat:@"%@%@",ss,dd];
        
        
        self.videoimg.hidden = NO;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:ee] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    }
    
    if ([dict[@"name"] isEqual:[NSNull null]]) {
        self.nameLabel.text = @"";
    }else{
        self.nameLabel.text = dict[@"name"];
    };
    
    //在线 空闲 忙碌
    if ([dict[@"online"] integerValue] == 1) {
        self.onlineimg.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([dict[@"online"] integerValue] == 2){
        self.onlineimg.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([dict[@"online"] integerValue] == 3){
        self.onlineimg.image = kGetImage(@"label_online");
    } else {
        self.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    
//    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
//
//        switch ([dict[@"identity"] integerValue]) {
//            case 0:
//                self.statusImg.image = nil;
//                break;
//            case 10:
//                self.statusImg.image = [UIImage imageNamed:@"huangjin2_1"];
//                break;
//            case 20:
//                self.statusImg.image = [UIImage imageNamed:@"bojin2_1"];
//                break;
//            case 30:
//                self.statusImg.image = [UIImage imageNamed:@"zuanshi2_1"];
//                break;
//            default:
//                break;
//        }
//    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
}



@end
