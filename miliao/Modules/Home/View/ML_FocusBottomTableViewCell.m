//
//  ML_FocusBottomTableViewCell.m
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import "ML_FocusBottomTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
#import "MLFocusApi.h"
@interface ML_FocusBottomTableViewCell()
@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *dashanbtn ;




@end


@implementation ML_FocusBottomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setCell];
//        self.contentView.backgroundColor = [UIColor colorFromHexString:@"#F3F3F3"];

    }
    return self;
}


-(void)setCell{
    
    
    UIView *bg = [[UIImageView alloc]init];
    bg.layer.cornerRadius = 8;
    bg.layer.masksToBounds = YES;
//    bg.layer.borderWidth = 1;
    bg.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width - 32);
        make.height.mas_equalTo(92);
    }];
    
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    img.layer.cornerRadius = 25;
    img.layer.masksToBounds = YES;
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(11+16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(70);
    }];
    [img layoutIfNeeded];
        
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).mas_offset(16);
        make.top.mas_equalTo(img.mas_top);
    }];
    
    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
    [self.dashanbtn setTitle:Localized(@"已关注", nil) forState:UIControlStateSelected];
    [self.dashanbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.dashanbtn.backgroundColor = kZhuColor;
    self.dashanbtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.dashanbtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    self.dashanbtn.layer.cornerRadius = 16;
    [self.contentView addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(73);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-38);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

//    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
//    [self.contentView addSubview:videobtn];
//    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(24);
//        make.right.mas_equalTo(dashanbtn.mas_left).mas_offset(-22);
//        make.centerY.mas_equalTo(dashanbtn.mas_centerY);
//    }];
    
    UILabel *tnameLabel = [[UILabel alloc]init];
//    tnameLabel.text = @"有点小内向但是熟了就...";
    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tnameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-150);
        make.bottom.mas_equalTo(img.mas_bottom);
    }];
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    [_img sd_setImageWithURL:kGetUrlPath(dict[@"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    
    if (![dict[@"name"] length]) {
        self.nameLabel.text = @"";
    }else{
       self.nameLabel.text = dict[@"name"];
        if (self.nameLabel.text.length > 8) {
            NSString *str1 = [self.nameLabel.text substringToIndex:8];//截取掉下标5之前的字符串
            self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
        }else{
            self.nameLabel.text = dict[@"name"];
        }
        
        CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(100, 22)];
//        self.nameLabel.frame = CGRectMake(76, 16, size.width, 22);
    }
    
    
    if (![dict[@"persionSign"] length]) {
        self.tnameLabel.text = @"";
    }else{
        self.tnameLabel.text = dict[@"persionSign"];
    };
    
    //关注状态，0-未关注 1-已关注
    if ([dict[@"focus"] integerValue] == 0) {//nv
        [self.dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
        self.dashanbtn.backgroundColor = [UIColor colorWithHexString:@"#FF88C9"];
    }else{
        [self.dashanbtn setTitle:Localized(@"已关注", nil) forState:UIControlStateNormal];
        self.dashanbtn.backgroundColor = [UIColor colorWithHexString:@"#666666"];
//        self.dashanbtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    [self.img layoutIfNeeded];
}

-(void)click{
    
    MLFocusApi *api = [[MLFocusApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:_dict[@"userId"] type:@"1"];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        self.dashanbtn.selected = YES;
        self.dashanbtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        NSLog(@"关注接口----%@",response.data);
        
        
        if (self.addCellTagBlock) {
            self.addCellTagBlock(self.tag);
        }
//        [self.ML_headview removeFromSuperview];
//        [self giveML_focusApi];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
    
}

//- (void)setIsChecked:(BOOL)isChecked{
//    _isChecked = isChecked;
//    //选中
//    if (_isChecked) {
//        self.selectimg.hidden = NO;
//    }
//    else{
//        self.selectimg.hidden = YES;
//    }
//}



@end
