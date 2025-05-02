//
//  MLMineHuiyuanCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "MLMineHuiyuanCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLMineHuiyuanCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *videoimg;




@end


@implementation MLMineHuiyuanCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor=[UIColor clearColor];
    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_chakanfangke_28_nor"];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.height.mas_equalTo(48*mWidthScale);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = @"会员勋章";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
    }];
    

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    titleLabel.textColor = [UIColor colorFromHexString:@"#a9a9ab"];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    if (kisCH) {
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(6);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            
        }];
    } else {
        titleLabel.frame = CGRectMake(0, 65, self.contentView.width, 45);
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
}








@end
