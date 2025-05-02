//
//  LDSGiftCollectionViewCell.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftCollectionViewCell.h"
#import "LDSGiftCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+ML.h"

@interface LDSGiftCollectionViewCell()

/** image */
@property(nonatomic,strong) UIImageView *giftImageView;
/** name */
@property(nonatomic,strong) UILabel *giftNameLabel;
/** money */
@property(nonatomic,strong) UILabel *moneyLabel;

@end

@implementation LDSGiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_SetUI];
    }
    return self;
}

#pragma mark -设置UI
- (void)p_SetUI {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    [self.bgView border:0.5 color:[UIColor whiteColor]];
    self.bgView.backgroundColor=kGetColor(@"f0f1f5");
    self.bgView.layer.cornerRadius=8;
    self.bgView.layer.masksToBounds=YES;
    [self.contentView addSubview:self.bgView];
    
    self.giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.width-10, 55)];
    self.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.giftImageView];
    
    self.giftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.giftImageView.frame), self.bounds.size.width, 16)];
    self.giftNameLabel.text = @"礼物名";
    self.giftNameLabel.textColor = [UIColor blackColor];
    self.giftNameLabel.textAlignment = NSTextAlignmentCenter;
    self.giftNameLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.giftNameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.giftNameLabel.frame), 30, 16)];
    moneyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    moneyLabel.font = [UIFont systemFontOfSize:10];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel = moneyLabel;
    [self.contentView  addSubview:moneyLabel];
}

- (void)setModel:(LDSGiftCellModel *)model {
    
    _model = model;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@""]];
    
    self.giftNameLabel.text = model.name;
    if(model.isSelected){
        self.bgView.backgroundColor=kGetColor(@"fffbe3");
        self.bgView.layer.borderColor=kGetColor(@"ffe962").CGColor;
        self.bgView.layer.borderWidth = 0.5;
    }else{
        self.bgView.backgroundColor=kGetColor(@"f0f1f5");
        self.bgView.layer.borderColor=[UIColor clearColor].CGColor;
        self.bgView.layer.borderWidth = 0;
//        self.bgView.layer.cornerRadius=8;
//        self.bgView.layer.masksToBounds=YES;
    }
//    self.bgView.hidden = !model.isSelected;
    
    NSString *moneyValue = [NSString stringWithFormat:@"%@%@",model.coin, Localized(@"米", nil)];
    self.moneyLabel.text = moneyValue;
    
    
    
//    CGSize size = [moneyValue sizeWithAttributes:@{NSFontAttributeName:self.moneyLabel.font}];
//    CGFloat w = size.width+1;
//    CGFloat labelX = (self.contentView.bounds.size.width-w+4+10)*0.5;
//    self.moneyLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.giftNameLabel.frame), w, 16);
    
    self.moneyLabel.frame = CGRectMake(0, CGRectGetMaxY(self.giftNameLabel.frame), self.width, 16);
}

@end
