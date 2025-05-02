

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
//#import "MASViewAttribute.h"

/**
 *  View的坐标拓展
 */
@interface UIView (ML)

//X轴
@property (nonatomic, assign) CGFloat x;
//Y轴
@property (nonatomic, assign) CGFloat y;
//右边X轴(只有GET)
@property (nonatomic, assign) CGFloat maxX;
//右边Y轴(只有GET)
@property (nonatomic, assign) CGFloat maxY;
//中心点X轴
@property (nonatomic, assign) CGFloat centerX;
//中心点Y轴
@property (nonatomic, assign) CGFloat centerY;
//宽度
@property (nonatomic, assign) CGFloat width;
//高度
@property (nonatomic, assign) CGFloat height;
//尺寸（width、height）
@property (nonatomic, assign) CGSize size;
//位置(X、Y)
@property (nonatomic, assign) CGPoint origin;

- (UIViewController *)getParentviewController;

// 添加昵称右边的一排标签
- (void)addTagSupView:(UIView *)tagSupView arr:(NSArray *)arr;
// 设置在线状态图片
- (void)addOnLineViewWithState:(NSString *)state;
// 在头像右边的昵称frame
- (void)setNameFrameWithOrigin:(CGPoint)point height:(CGFloat)height;
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;
@end
