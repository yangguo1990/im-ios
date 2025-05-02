//
//  ML_MineCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_MineCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface ML_MineCollectionViewCell()

@property (nonatomic,strong)UIImageView *selectImg;

@property (nonatomic,strong)UIImageView *statusImg;

@end


@implementation ML_MineCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

@end
