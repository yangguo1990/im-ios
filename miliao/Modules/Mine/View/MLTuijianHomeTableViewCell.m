//
//  MLTuijianHomeTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/10.
//

#import "MLTuijianHomeTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface MLTuijianHomeTableViewCell()

@end

@implementation MLTuijianHomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    UILabel *titlelabel = [[UILabel alloc]init];
    //titlelabel.text = @"邀请来的其他用户";
    titlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titlelabel.numberOfLines = 0;
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;

}

- (void)addSubview:(UIView *)view {

    if (![view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]] && view) {
        
         [super addSubview:view];
    }
}


@end



