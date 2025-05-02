//
//  ML_MineSexSelectTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import "ML_MineSexSelectTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface ML_MineSexSelectTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;

@end


@implementation ML_MineSexSelectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

-(void)setCell{
    
    UIView *backV1 = [[UIView alloc]initWithFrame:CGRectZero];
    backV1.layer.cornerRadius = 12*mWidthScale;
    backV1.layer.masksToBounds = YES;
    backV1.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:backV1];
    [backV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(5*mHeightScale);
        make.bottom.mas_equalTo(-5*mHeightScale);
        make.width.mas_equalTo(168*mWidthScale);
    }];
    
    UIView *backV2 = [[UIView alloc]initWithFrame:CGRectZero];
    backV2.layer.cornerRadius = 12*mWidthScale;
    backV2.layer.masksToBounds = YES;
    backV2.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:backV2];
    [backV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(5*mHeightScale);
        make.bottom.mas_equalTo(-5*mHeightScale);
        make.width.mas_equalTo(168*mWidthScale);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"生日", nil);
    titlelabel.font = [UIFont boldSystemFontOfSize:14];
    titlelabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(32);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UILabel *subtitlelabel = [[UILabel alloc]init];
    subtitlelabel.text = @"请选择";
    //subtitlelabel.backgroundColor = UIColor.redColor;
    subtitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    subtitlelabel.textColor = [UIColor colorFromHexString:@"#999999"];
    subtitlelabel.userInteractionEnabled = YES;
    subtitlelabel.numberOfLines = 0;
    UITapGestureRecognizer *toptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topClick)];
    [subtitlelabel addGestureRecognizer:toptap];
    [self.contentView addSubview:subtitlelabel];
    self.subtitlelabel = subtitlelabel;
    [subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];

    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-16);
    }];
    
    UILabel *bottomtitlelabel = [[UILabel alloc]init];
    bottomtitlelabel.text = Localized(@"性别", nil);
    bottomtitlelabel.font = [UIFont boldSystemFontOfSize:14];
    bottomtitlelabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [self.contentView addSubview:bottomtitlelabel];
    self.bottomtitlelabel = bottomtitlelabel;
    [bottomtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UILabel *bottomsubtitlelabel = [[UILabel alloc]init];
    bottomsubtitlelabel.text = @"请选择";
    bottomsubtitlelabel.userInteractionEnabled = YES;
    //bottomsubtitlelabel.backgroundColor = UIColor.blueColor;
    bottomsubtitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    bottomsubtitlelabel.textColor = [UIColor colorFromHexString:@"#999999"];
    UITapGestureRecognizer *bottomtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomClick)];
    [bottomsubtitlelabel addGestureRecognizer:bottomtap];
    [self.contentView addSubview:bottomsubtitlelabel];
    self.bottomsubtitlelabel = bottomsubtitlelabel;
    [bottomsubtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomtitlelabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];

    UIImageView *bottomselectimg = [[UIImageView alloc]init];
    bottomselectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:bottomselectimg];
    self.bottomselectimg = bottomselectimg;
    [bottomselectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
}


-(void)bottomClick{
    if (self.bottomBlock) {
        self.bottomBlock();
    }
}

-(void)topClick{
 
    if (self.topBlock) {
        self.topBlock();
    }
}



@end

