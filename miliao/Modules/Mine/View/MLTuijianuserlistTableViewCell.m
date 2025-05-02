//
//  MLTuijianuserlistTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLTuijianuserlistTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface MLTuijianuserlistTableViewCell()

@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *jinView;
@end

@implementation MLTuijianuserlistTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"Ellipse 24"];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    self.img =imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(44);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
    }];
    [imageView layoutIfNeeded];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"邀请来的其他用户";
    titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
        make.top.mas_equalTo(imageView.mas_top);
    }];
        
    UILabel *indextitlelabel = [[UILabel alloc]init];
//    indextitlelabel.text = @"2022-07-25 19:30";
    indextitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#666666"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(imageView.mas_bottom).mas_offset(0);
    }];
    
    
    UILabel *jinView = [[UILabel alloc] init];
//    jinView.text = @"2022-07-25 19:30";
    jinView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    jinView.textColor = kZhuColor;
    jinView.textAlignment = NSTextAlignmentRight;
    [self addSubview:jinView];
    self.jinView = jinView;
    
}


-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.jinView.frame = CGRectMake(ML_ScreenWidth - 16 - 200, 28, 200, 20);
    self.jinView.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"获得", nil), dict[@"credit"], Localized(@"积分", nil)];
    self.jinView.hidden = !dict[@"credit"];
    
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"icon"]];
    [_img sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    self.titlelabel.text = _dict[@"name"];
    self.indextitlelabel.text = _dict[@"createTime"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    [self.img layoutIfNeeded];
}






@end



