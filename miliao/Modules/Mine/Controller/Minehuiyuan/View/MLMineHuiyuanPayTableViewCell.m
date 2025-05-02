//
//  MLMineHuiyuanPayTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "MLMineHuiyuanPayTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface MLMineHuiyuanPayTableViewCell()

@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@property (nonatomic,strong)UIButton *dashanbtn;
@end


@implementation MLMineHuiyuanPayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCell];
    }
    return self;
}


-(void)setCell{

    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_zhifubao_26_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(26);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"支付宝";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectimg.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIImageView *selectimgrigth = [[UIImageView alloc]init];
    selectimgrigth.image = [UIImage imageNamed:@"icon_gouxuan_16_sel-1"];
    //UITapGestureRecognizer *tapgise = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
    //[selectimgrigth addGestureRecognizer:tapgise];    
    [self.contentView addSubview:selectimgrigth];
    self.selectimgrigth = selectimgrigth;
    [selectimgrigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
}

- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.selectimgrigth.image = [UIImage imageNamed:@"icon_gouxuan_16_sel"];
    }
    else{
        self.selectimgrigth.image = [UIImage imageNamed:@"icon_gouxuan_16_sel-1"];
    }
}

@end
