//
//  YBIBVideoTopBar.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2019/7/11.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "YBIBVideoTopBar.h"
#import "YBIBIconManager.h"

@interface YBIBVideoTopBar ()
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation YBIBVideoTopBar

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = 54;
    self.cancelButton.frame = CGRectMake(0,  20, buttonWidth, 40);
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 60;
}

#pragma mark - getter

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:kGetImage(@"icon_back_24_FFF_nor") forState:UIControlStateNormal];
        _cancelButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _cancelButton.layer.shadowOffset = CGSizeMake(0, 1);
        _cancelButton.layer.shadowOpacity = 1;
        _cancelButton.layer.shadowRadius = 4;
    }
    return _cancelButton;
}



@end
