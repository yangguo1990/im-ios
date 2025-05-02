//
//  ML_hotsmessageCollectionViewCell.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_hotsmessageCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_hotsmessageCollectionViewCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;

@property (nonatomic,strong)UIImageView *statusImg;

@end


@implementation ML_hotsmessageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"weiniyou"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    
}





@end
