#import "Rob_euCHNRefreshFooter.h"
#import "UIView+AnimationExtend.h"
@interface Rob_euCHNRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic)UIImageView *imageViewLoading;
@end
@implementation Rob_euCHNRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    self.mj_h = 50;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p_refresh_loading_add"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.imageViewLoading = logo;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.imageViewLoading.bounds = CGRectMake(0, 0, 16, 16);
    self.imageViewLoading.center = CGPointMake(self.mj_w * 0.5 + 60, self.mj_h * 0.5);
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = Localized(@"上拉加载数据", nil);
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading stopRotationAnimation];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = Localized(@"正在努力加载", nil);
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading rotationAnimation];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = Localized(@"我也是有底线的", nil);
            self.imageViewLoading.hidden = YES;
            [self.imageViewLoading stopRotationAnimation];
            break;
        default:
            break;
    }
}
@end
