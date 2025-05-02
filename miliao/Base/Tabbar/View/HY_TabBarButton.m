#define HY_TabBarButtonImageRatio 0.6
#import "HY_TabBarButton.h"
#import "HY_BadgeButton.h"
@interface HY_TabBarButton()
@property (nonatomic, weak) HY_BadgeButton *badgeButton;
@end
@implementation HY_TabBarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        
        [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateSelected];
        HY_BadgeButton *badgeButton = [[HY_BadgeButton alloc] init];
        badgeButton.layer.borderWidth = 1;
        badgeButton.layer.borderColor = [kGetColor(@"#ffffff") CGColor]; // 边框
        badgeButton.backgroundColor = [UIColor redColor];
//        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted {}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * HY_TabBarButtonImageRatio;
    return CGRectMake(0, 2, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * HY_TabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    self.badgeButton.badgeValue = self.item.badgeValue;
    
}
@end
