#import "HY_BadgeButton.h"
@implementation HY_BadgeButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        UIImage *image = [UIImage imageNamed:@"main_badge"];
        [self setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}
- (void)setBadgeValue:(NSString *)badgeValue
{
//#warning copy
    if ([badgeValue intValue] > 99) {
        badgeValue = @"99+";
    }
    _badgeValue = [badgeValue copy];
    if ([badgeValue intValue] > 0) {
        self.hidden = NO;
        [self setTitle:badgeValue forState:UIControlStateNormal];
        CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(50, 25)];
        CGFloat badgeW = 23;
        CGFloat badgeH = 23;
        if (badgeValue.length > 2) {
            badgeW = 33;
            CGFloat badgeH = 20;
        }
        self.frame = CGRectMake(ML_ScreenWidth / 4 / 2 + 10, 5, badgeW, badgeH);
        self.layer.cornerRadius = badgeH / 2;
    } else {
        self.hidden = YES;
    }
    
}
@end
