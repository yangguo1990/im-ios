#import "Rob_euCHNRefreshGifHeader.h"
#define HNRefreshStateRefreshingImagesCount 2
@interface Rob_euCHNRefreshGifHeader()
@property (weak, nonatomic) UILabel *label;
@end
@implementation Rob_euCHNRefreshGifHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    self.mj_h = 50;
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i< HNRefreshStateRefreshingImagesCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Rob_euColdPub_dropdown_loading_0%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.label = label;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = CGRectMake(0, self.mj_h - 15, self.mj_w, 15);
    self.gifView.frame = CGRectMake((self.mj_w - 25) / 2.0, 5, 25, 25);
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = Localized(@"下拉推荐", nil);
            break;
        case MJRefreshStatePulling:
            self.label.text = Localized(@"松开推荐", nil);
            break;
        case MJRefreshStateRefreshing:
            self.label.text = Localized(@"推荐中", nil);
            break;
        default:
            break;
    }
}
@end
