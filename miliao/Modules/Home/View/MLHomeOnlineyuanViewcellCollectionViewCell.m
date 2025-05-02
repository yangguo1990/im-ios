//
//  MLHomeOnlineyuanViewcellCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import "MLHomeOnlineyuanViewcellCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface MLHomeOnlineyuanViewcellCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;


@end


@implementation MLHomeOnlineyuanViewcellCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
//    imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.alpha = 1;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionRepeat animations:^{
            self.imageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.imageView.alpha = 0.6;
        [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionRepeat animations:^{
            self.imageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.imageView.alpha = 0.2;
        }];
    }];
}






@end
