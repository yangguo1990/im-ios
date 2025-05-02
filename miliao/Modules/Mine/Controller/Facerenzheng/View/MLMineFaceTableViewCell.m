//
//  MLMineFaceTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLMineFaceTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface MLMineFaceTableViewCell()

@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UIImageView *image;

@end

@implementation MLMineFaceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"iocn_zhenrenrenzheng_70_nor"];
    [self addSubview:imageView];
    self.image = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(74);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"完成真人主播认证", nil);
    titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(8);
        //make.top.mas_equalTo(imageView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(imageView.mas_centerY).mas_offset(-5);
    }];

    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = Localized(@"可接视频，发私信赚收益", nil);
    indextitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#666666"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(8);
        //make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(11);
        make.top.mas_equalTo(imageView.mas_centerY).mas_offset(5);
    }];
    
    UIImageView *backimageView =[[UIImageView alloc]init];
    backimageView.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self addSubview:backimageView];
    [backimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(14);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
    }];
    
}

- (void)setType:(MLMineFaceTableViewCellFace)type{
    if (type == MLMineFaceTableViewCellface) {
        self.image.image = [UIImage imageNamed:@"iocn_zhenrenrenzheng_70_nor"];
        self.titlelabel.text = Localized(@"完成真人主播认证", nil);
        self.indextitlelabel.text = Localized(@"可接视频，发私信赚收益", nil);
    }else{
        self.image.image = [UIImage imageNamed:@"icon_shimingrenzheng_70_or"];
        self.titlelabel.text = Localized(@"完成实名认证", nil);
        self.indextitlelabel.text = Localized(@"可获得更多特权", nil);
}
}

@end

