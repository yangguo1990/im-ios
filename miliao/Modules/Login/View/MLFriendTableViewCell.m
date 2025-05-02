//
//  MLFriendTableViewCell.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLFriendTableViewCell.h"
#import <Masonry/Masonry.h>

@interface MLFriendTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;

@end


@implementation MLFriendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"tuPhot"];
    UITapGestureRecognizer *tapgise = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
    [img addGestureRecognizer:tapgise];
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
    [img addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
    }];
}

-(void)imgClick{
    if (self.addToCartsBlock) {
        self.addToCartsBlock();
    }
}

- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.selectimg.hidden = NO;
    }
    else{
        self.selectimg.hidden = YES;
    }
}



@end
