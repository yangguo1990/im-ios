//
//  ML_SettingSwichTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SettingSwichTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_SettingSwichTableViewCell()
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@end

@implementation ML_SettingSwichTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5*mHeightScale);
        make.bottom.mas_equalTo(-5*mHeightScale);
    }];
    backView.layer.cornerRadius = 12*mHeightScale;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = UIColor.whiteColor;
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"开通会员", nil);
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"Group 2134"];
    selectimg.hidden = YES;
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(8);
    }];
    
    UIButton *setnetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setnetbtn setImage:[UIImage imageNamed:@"icon_weixuanzhong_nor"] forState:UIControlStateNormal];
    [setnetbtn setImage:[UIImage imageNamed:@"icon_xuanzhong_sel"] forState:UIControlStateSelected];
    [setnetbtn addTarget:self action:@selector(swicthClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:setnetbtn];
    self.setnetbtn = setnetbtn;
    [setnetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(54);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
    
}

-(void)swicthClick:(UIButton *)btn{
   
     if (self.swichBlock) {
        self.swichBlock(self.index, btn);
    }
}
@end
