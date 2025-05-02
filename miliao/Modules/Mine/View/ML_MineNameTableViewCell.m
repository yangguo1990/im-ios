//
//  ML_MineNameTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import "ML_MineNameTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface ML_MineNameTableViewCell()

@end


@implementation ML_MineNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    self.backgroundColor = UIColor.clearColor;
    UIView *backV = [[UIView alloc]initWithFrame:CGRectZero];
    backV.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:backV];
    backV.layer.cornerRadius = 12*mWidthScale;
    backV.layer.masksToBounds = YES;
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(5*mHeightScale);
        make.bottom.mas_equalTo(-5*mHeightScale);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"昵称", nil);
    titlelabel.font = [UIFont boldSystemFontOfSize:14];
    titlelabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    
    UILabel *subtitlelabel = [[UILabel alloc]init];
    subtitlelabel.text = @"请输入昵称";
    subtitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    subtitlelabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.contentView addSubview:subtitlelabel];
    self.subtitlelabel = subtitlelabel;
    [subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-32);
    }];
}


@end

