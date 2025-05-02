//
//  MLHomeOnlineBottomView.h
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//确定按钮点击事件
typedef void(^sureBlock)(void);

@interface MLHomeOnlineBottomView : UIView

@property(nonatomic,copy)sureBlock sure_block;

@end

NS_ASSUME_NONNULL_END
