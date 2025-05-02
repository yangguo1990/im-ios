//
//  ML_MineHeadTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import "ML_MineHeadTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface ML_MineHeadTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@end


@implementation ML_MineHeadTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
        self.contentView.hidden = YES;
    }
    return self;
}


-(void)setCell{
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"头像";
    titlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    
    UIImageView *headimg = [[UIImageView alloc]init];
    headimg.layer.cornerRadius = 20;
    headimg.layer.masksToBounds = YES;
    headimg.image = [UIImage imageNamed:@"Slice 46"];
    [self.contentView addSubview:headimg];
    self.headimg = headimg;
    [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.headimg.layer.cornerRadius = self.headimg.frame.size.width / 2;
    self.headimg.layer.masksToBounds = YES;
}

@end

