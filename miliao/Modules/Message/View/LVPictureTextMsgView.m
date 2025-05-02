//
//  LVPictureTextMsgView.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/11/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "LVPictureTextMsgView.h"
#import "M80AttributedLabel+NIMKit.h"

@interface LVPictureTextMsgView()
@end
@implementation LVPictureTextMsgView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.label];
    }
    return self;
}

-(void) setTextMsgContent:(NSString *) textContent
{
    [self.label nim_setText:textContent];
}

-(void) pictureViewWithMaxWidth:(NSInteger) maxWidth
{
    CGSize contentSize = [self.label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    self.frame = CGRectMake(0, 0, contentSize.width+1, contentSize.height+1);
    self.label.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    [self setNeedsLayout];
}

- (M80AttributedLabel *)label
{
    if (_label) {
        return _label;
    }
    _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    _label.lineSpacing = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0;
    return _label;
}

@end
