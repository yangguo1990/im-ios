//
//  ML_HotCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import "ML_HotCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ML.h"

@interface ML_HotCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *videoimg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *statusImg;

@property (nonatomic,strong)AVPlayerItem *playerItem;
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerLayer *playerLayer;
@property (nonatomic,strong)UIView *videoView;

@end


@implementation ML_HotCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"人气推荐占位图"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    [imageView addSubview:statusImg];
    self.statusImg = statusImg;
    [statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageView.mas_right).mas_offset(-6);
        make.top.mas_equalTo(imageView.mas_top).mas_offset(4);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
    
}

-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    if ([dict[@"coverType"] integerValue] == 0) {
        self.videoimg.hidden = YES;
//        self.playerLayer = nil;
//        [self.playerLayer removeFromSuperlayer];
//        self.playerItem = nil;
        [_imageView sd_setImageWithURL:kGetUrlPath(dict[@"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        //[self.player pause];

    }else{
        NSString *cover = dict[@"cover"];
        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";

        NSString *icon = [NSString stringWithFormat:@"%@%@", cover, dd];
        NSURL *ee = kGetUrlPath(icon);
        
        self.videoimg.hidden = YES;
        if ([dict[@"cover"] containsString:@".gif"]) {
            [_imageView sd_setImageWithURL:kGetUrlPath(dict[@"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        } else {
            [_imageView sd_setImageWithURL:ee placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        }
    }
    
    if ([dict[@"name"] isEqual:[NSNull null]]) {
        self.nameLabel.text = @"";
    }else{
        self.nameLabel.text = dict[@"name"];
    };
    
    //在线状态，0-离线 1-勿扰 2-在聊 3-在线
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
-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
}


@end
