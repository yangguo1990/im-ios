//
//  MLDynameSHowTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/19.
//

#import "MLDynameSHowTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface MLDynameSHowTableViewCell()
@end


@implementation MLDynameSHowTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setCell];
    }
    return self;
}

-(void)setCell{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小可爱";
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
 
}



@end

