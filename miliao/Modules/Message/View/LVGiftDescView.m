//
//  LVGiftDescView.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/8/1.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "LVGiftDescView.h"

@interface LVGiftDescView()
{
    UILabel * _titleLabel;
    UILabel * _desLabel;
}
@end
@implementation LVGiftDescView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.text = @"送出礼物";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_titleLabel];
        
        _desLabel = [UILabel new];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.font = [UIFont systemFontOfSize:11.0];
        [self addSubview:_desLabel];
    }
    
    return self;
}

-(void) setGiftTitle:(NSString *) giftTitle count:(NSString *) count outGoing:(BOOL) outGoing
{
    if(outGoing){
        _desLabel.textColor = [UIColor colorWithHexString:@"#A86F73"];
    }else{
        _desLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    _desLabel.text = [NSString stringWithFormat:@"%@ X %@",giftTitle?:Localized(@"礼物", nil),count?:@"1"];
    [_desLabel sizeToFit];
    [_titleLabel sizeToFit];
    
    [self setNeedsLayout];
}

-(void) descViewFitSize
{
    CGFloat titleWidth = CGRectGetWidth(_titleLabel.frame) + 1;
    CGFloat descWidth = CGRectGetWidth(_desLabel.frame) +  1;
    CGFloat width = MAX(titleWidth, descWidth);
    CGFloat height = 37;
    
    self.frame = CGRectMake(0, 0, width, height);
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat textInterval = 5;
    CGFloat minY = (height - CGRectGetHeight(_titleLabel.frame) - CGRectGetHeight(_desLabel.frame) -textInterval)/2;
    _titleLabel.frame = CGRectMake(0, minY, width, CGRectGetHeight(_titleLabel.frame));
    
    _desLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+textInterval, width, CGRectGetHeight(_desLabel.frame));
    
}

@end
