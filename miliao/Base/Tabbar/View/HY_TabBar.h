#import <UIKit/UIKit.h>
@class HY_TabBar;
#define tabarMoIndel 0
@protocol HY_TabBarDelegate <NSObject>
@optional
- (void)tabBar:(HY_TabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBarDidClickedPlusButton:(HY_TabBar *)tabBar;
@end
@interface HY_TabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<HY_TabBarDelegate> delegate;
@end
