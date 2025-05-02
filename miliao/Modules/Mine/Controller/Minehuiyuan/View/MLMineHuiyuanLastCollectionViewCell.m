//
//  MLMineHuiyuanLastCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "MLMineHuiyuanLastCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLMineHuiyuanLastCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *videoimg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *statusImg;



@end


@implementation MLMineHuiyuanLastCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_fenxiang_24_000_nor"];
    imageView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(16);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"敬请期待";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titleLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);

    }];

}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
}








@end
