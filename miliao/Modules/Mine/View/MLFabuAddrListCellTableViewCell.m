//
//  MLFabuAddrListCellTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabuAddrListCellTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface MLFabuAddrListCellTableViewCell()
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *indextitlelabel;

@property (nonatomic,strong)UIImageView *statusimg;

@end

@implementation MLFabuAddrListCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"坂田(地铁站)";
    titlelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(11);
        //make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = @"深圳市龙岗区5号线/环中线";
    indextitlelabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#666666"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        //make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-11);
    }];

    UIImageView *statusimg = [[UIImageView alloc]init];
    statusimg.image = [UIImage imageNamed:@"icon_gouxuan_18_sel"];
    [self.contentView addSubview:statusimg];
    self.statusimg = statusimg;
    [statusimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.titlelabel.text = _dict[@"name"];
    if ([_dict[@"area"] isEqualToString:@""]) {
        self.indextitlelabel.text = @"暂无详细地址";
    }else{
        self.indextitlelabel.text = _dict[@"area"];
    }
}


- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.statusimg.hidden = NO ;
    }
    else{
        self.statusimg.hidden = YES;
    }
}




@end



