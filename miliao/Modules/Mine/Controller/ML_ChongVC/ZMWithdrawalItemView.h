//
//  ZMWithdrawalItemView.h
//  SiLiaoBack
//
//  Created by tg on 2023/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMWithdrawalItemView : UIView

- (void)refreshViewWithIcon:(NSString *)icon title:(NSString *)title bind:(BOOL)bind;
- (void)setSelected:(BOOL)selected;


@end

NS_ASSUME_NONNULL_END
