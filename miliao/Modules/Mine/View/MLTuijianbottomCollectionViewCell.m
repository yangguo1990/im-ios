//
//  MLTuijianbottomCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/10/27.
//

#import "MLTuijianbottomCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLTuijianbottomCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;

@property (nonatomic,strong)UIImageView *statusImg;

@end


@implementation MLTuijianbottomCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"icon_guanzhuyufensi_36_nor"];
    imageView.layer.cornerRadius = 16;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(17);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(44);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"关注与粉丝", nil);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

@end
