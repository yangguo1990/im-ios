//
//  AppCell.m
//  facetest
//
//  Created by apple on 2022/8/16.
//

#import "AppCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface AppCell()

@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *imageView;

@property  (nonatomic,strong)UILabel *nameLabel;
@property  (nonatomic,strong)UILabel *titleLabel;


@end


@implementation AppCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"tuPhot"];
    imageView.layer.cornerRadius = 16;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(104);
    }];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"喜欢音乐";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(16);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
        
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"6999个男生";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titleLabel.textColor = [UIColor colorFromHexString:@"999999"];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
            
    }];
        
    UIView *bgview =[[UIImageView alloc]init];
    bgview.layer.cornerRadius = 16;
    bgview.layer.masksToBounds = YES;
    bgview.backgroundColor = [UIColor colorFromHexString:@"000000"];
    bgview.alpha = 0.5;
    [imageView addSubview:bgview];
    self.bgview = bgview;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(104);
    }];
    
    UIImageView *selectImg =[[UIImageView alloc]init];
    selectImg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
    selectImg.layer.cornerRadius = 16;
    selectImg.layer.masksToBounds = YES;
    [imageView addSubview:selectImg];
    self.selectImg = selectImg;
    [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(26);
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.centerY.mas_equalTo(imageView.mas_centerY);
    }];
}


- (void)setIsChecked:(BOOL)isChecked{
       _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.bgview.hidden = NO;
        self.selectImg.hidden = NO;
    }
    else{
       self.bgview.hidden = YES;
       self.selectImg.hidden = YES;
    }
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.nameLabel.text = _dict[@"title"];
    self.titleLabel.text = _dict[@"content"];
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"imagePath"]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
}




//-(void)setSelected:(BOOL)selected{
//
//    [super setSelected:selected];
//    if (selected) {
//        self.bgview.hidden = YES;
//        self.selectImg.hidden = YES;
//    }else{
//       self.bgview.hidden = YES;
//       self.selectImg.hidden = YES;
//    }
//}





//-(void)setSelected:(BOOL)selected{
//    _isSelected = selected;
//
//    if (_isSelected) {
//        self.bgview.hidden = YES;
//        self.selectImg.hidden = YES;
//    }
//    else{
//        self.bgview.hidden = NO;  //改变了文本的颜色
//        self.selectImg.hidden = NO;
//    }
//}

//-(void)setIsSelectedState:(BOOL)isSelectedState{
//    _isSelectedState = isSelectedState;
//    if (_isSelectedState) {
//        self.bgview.hidden = YES;
//        self.selectImg.hidden = YES;
//    }
//    else{
//        self.bgview.hidden = NO;  //改变了文本的颜色
//        self.selectImg.hidden = NO;
//    }
//}


@end
