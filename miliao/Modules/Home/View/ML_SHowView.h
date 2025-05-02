//
//  ML_SHowView.h
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消按钮点击事件
typedef void(^cancelBlock)(void);
//确定按钮点击事件
typedef void(^sureBlock)(void);

@interface ML_SHowView : UIView

- (void)hiddenView;
@property(nonatomic,copy)cancelBlock cancel_block;

@property(nonatomic,copy)sureBlock sure_block;
- (void)show;

- (void)setDic:(NSDictionary *)dic sureBtClcik:(sureBlock)sureBlock cancelClick:(cancelBlock)cancelBlock;

@end

NS_ASSUME_NONNULL_END
