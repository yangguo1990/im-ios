//
//  ML_HostGexingTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "ML_HostGexingTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_HostGexingTableViewCell()
@property (nonatomic,strong)UIView *liveV2;
@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIImageView *statusImg;
@property (nonatomic,strong)UILabel *tnameLabel;
@end


@implementation ML_HostGexingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

-(void)setCell{

        UILabel *tnameLabel = [[UILabel alloc]init];
        tnameLabel.text = Localized(@"个性签名", nil);
        tnameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        tnameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [self.contentView addSubview:tnameLabel];
        [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(16);
        }];
    self.tnameLabel = tnameLabel;

        UILabel *adrrnameLabel = [[UILabel alloc]init];
//        adrrnameLabel.text = @"我要变成一个可以让你永远感到温暖的小太阳，我要变成一个可以让你永远感到温暖的小太阳。";
        adrrnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        adrrnameLabel.numberOfLines = 0;
        adrrnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        [self.contentView addSubview:adrrnameLabel];
        self.adrrnameLabel = adrrnameLabel;
//        [adrrnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
//            make.top.mas_equalTo(tnameLabel.mas_bottom).mas_offset(8);
//            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-16);
//        }];
    
    //@property (nonatomic,strong)UIView *liveV2;
    
   // self.liveV2.frame = CGRectMake(16, self.height - 1, ML_ScreenWidth - 32, 1);
    UIView *liveV2 = [[UIView alloc] init];
    liveV2.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:liveV2];
    self.liveV2 = liveV2;
}

- (void)setAdrrnameStr:(NSString *)adrrnameStr
{
    _adrrnameStr = adrrnameStr;
    self.adrrnameLabel.hidden = ![adrrnameStr length];
    self.liveV2.hidden = self.adrrnameLabel.hidden;
    self.tnameLabel.hidden = self.adrrnameLabel.hidden;;
    
    CGSize size = [adrrnameStr sizeWithFont:self.adrrnameLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 32, 300)];
    
    self.adrrnameLabel.text = adrrnameStr;
    self.adrrnameLabel.frame = CGRectMake(16, 50, size.width, size.height);
    self.liveV2.frame = CGRectMake(16, CGRectGetMaxY(self.adrrnameLabel.frame) + 9, ML_ScreenWidth - 32, 1);
}


@end
