//
//  MLMineBiaoqianCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLMineBiaoqianCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLMineBiaoqianCollectionViewCell()

@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *videoimg;
@property (nonatomic,strong)UIImageView *statusImg;

@end


@implementation MLMineBiaoqianCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIView*bgView =[[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorFromHexString:@"#EEEEEE"];
    bgView.layer.cornerRadius = 16;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgView];
    self.bgview = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];


    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"优雅大方";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
//    nameLabel.userInteractionEnabled = YES;
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
}


-(void)tapClick{
    if (self.returnBlock) {
        self.returnBlock(self.nameLabel, self.bgview);
    }
    
    
}





@end
