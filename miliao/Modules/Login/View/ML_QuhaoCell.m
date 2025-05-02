//
//  MLDynameSHowTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/19.
//

#import "ML_QuhaoCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

@interface ML_QuhaoCell()
@end


@implementation ML_QuhaoCell

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
    
    UILabel *nameLabel2 = [[UILabel alloc]init];
    nameLabel2.textAlignment = NSTextAlignmentRight;
    nameLabel2.numberOfLines = 0;
    nameLabel2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel2.textColor = [UIColor colorFromHexString:@"#333333"];
//    #835DFF
    [self.contentView addSubview:nameLabel2];
    self.nameLabel2 = nameLabel2;
    [nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
 
}



@end

