//
//  MLFabuSelectCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabuSelectCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface MLFabuSelectCollectionViewCell()
@end

@implementation MLFabuSelectCollectionViewCell

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
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.masksToBounds = YES;
    img.layer.cornerRadius = 8;
    img.image = [UIImage imageNamed:@"Slice 13"];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.right.top.bottom.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(90);
    }];
    
    UIImageView *delectimg = [[UIImageView alloc]init];
    delectimg.contentMode = UIViewContentModeScaleAspectFill;
    delectimg.layer.masksToBounds = YES;
    img.userInteractionEnabled = YES;
    delectimg.userInteractionEnabled = YES;
    delectimg.image = [UIImage imageNamed:@"Slice 5"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgclick)];
    [delectimg addGestureRecognizer:tap];
    [self.contentView addSubview:delectimg];
    self.delectimg = delectimg;
    //huself.delectimg = delectimg;
    [delectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(img);
        make.height.width.mas_equalTo(25);
    }];
}

-(void)imgclick{
    self.cancel_block();
}


@end

