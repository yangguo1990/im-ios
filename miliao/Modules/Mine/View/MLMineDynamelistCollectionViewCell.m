//
//  MLMineDynamelistCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLMineDynamelistCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface MLMineDynamelistCollectionViewCell()

@end

@implementation MLMineDynamelistCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        self.contentView.userInteractionEnabled = YES;
    }
    return self;
}

-(void)createUI{
    UIImageView *img = [[UIImageView alloc]init];
    img.contentMode = UIViewContentModeScaleAspectFit;
   
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

-(void)imgclick{

}


@end

