//
//  MLFabudynamicTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabudynamicTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface MLFabudynamicTableViewCell()


@end

@implementation MLFabudynamicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(1);
    }];
        
    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_wodeweizhi_24_nor"];
    //imageView.layer.cornerRadius = 16;
    //imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"我的位置", nil);
    titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(imageView.mas_centerY);
    }];
    
    UIImageView *backimageView =[[UIImageView alloc]init];
    backimageView.image = [UIImage imageNamed:@"Slice 3"];
    [self addSubview:backimageView];
    [backimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
        make.width.height.mas_equalTo(14);
    }];
    
    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = Localized(@"请选择定位", nil);
    indextitlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    indextitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#999999"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backimageView.mas_left).mas_offset(0);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
    }];
  
    
}



@end



