//
//  MLMineXingxiangTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLMineXingxiangTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface MLMineXingxiangTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@end


@implementation MLMineXingxiangTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"个人标签", nil);
    titlelabel.font = [UIFont boldSystemFontOfSize:14];
    titlelabel.textColor = kGetColor(@"000000");
    [self.contentView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(32);
    }];

    
    UILabel *subtitlelabel = [[UILabel alloc]init];
    subtitlelabel.text = @"(0/3)";
    subtitlelabel.font = [UIFont boldSystemFontOfSize:14];
    subtitlelabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [self.contentView addSubview:subtitlelabel];
    self.subtitlelabel = subtitlelabel;
    [subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
    }];


    UIView *bgview = [[UIView alloc]init];
    [self.contentView addSubview:bgview];
    self.bgview = bgview;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-130);
        make.height.mas_equalTo(25);
    }];
    
    
    UILabel *titlmessage = [[UILabel alloc]init];
    titlmessage.text = Localized(@"我的形象标签", nil);
    titlmessage.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlmessage.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.contentView addSubview:titlmessage];
    self.titlmessage = titlmessage;
    [titlmessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_left).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];

}


@end


