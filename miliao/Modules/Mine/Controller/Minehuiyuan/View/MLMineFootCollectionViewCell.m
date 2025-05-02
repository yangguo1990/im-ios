//
//  MLMineFootCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "MLMineFootCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLMineFootCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *videoimg;





@end


@implementation MLMineFootCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
    }];

    UIImageView *topimgView =[[UIImageView alloc]init];
    topimgView.image = [UIImage imageNamed:@"Slice 20"];
    [self.contentView addSubview:topimgView];
    self.topimgView = topimgView;
    [topimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(imageView.mas_top).mas_offset(0);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(19);
    }];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"送198金币";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    [topimgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topimgView.mas_centerX);
        make.centerY.mas_equalTo(topimgView.mas_centerY);
    }];

    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.text = @"1个月";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor colorFromHexString:@"#594322"];
    [imageView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.top.mas_equalTo(imageView.mas_top).mas_offset(12);
    }];
    
    UILabel *subtitleLabel = [[UILabel alloc]init];
//    subtitleLabel.text = @"¥38";
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    subtitleLabel.textColor = [UIColor colorFromHexString:@"#9E825B"];
    [imageView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(3);
    }];
    
//    UIImageView *selectimgView =[[UIImageView alloc]init];
//    selectimgView.image = [UIImage imageNamed:@"xuanzhong"];
//    [imageView addSubview:selectimgView];
//    self.selectimgView = selectimgView;
//    [selectimgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self);
//        make.bottom.mas_equalTo(imageView.mas_bottom).mas_offset(0);
//        make.width.mas_equalTo(28);
//        make.height.mas_equalTo(28);
//    }];
    
}

- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.selectimgView.hidden = NO ;
    }
    else{
        self.selectimgView.hidden = YES;
    }
}


@end
