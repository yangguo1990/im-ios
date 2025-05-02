//
//  ZMPayItemView.h
//  SiLiaoBack
//
//  Created by tg on 2023/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMPayItemView : UIView

@property (nonatomic, strong) UIButton *selectBtn;

- (void)refreshViewWithIcon:(NSString *)icon title:(NSString *)title tag:(NSInteger )tag;

- (void)setSelected:(BOOL)selected;

@property (nonatomic, copy) void(^selectBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
