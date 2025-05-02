//
//  MLZhuxiaoShowView.h
//  miliao
//
//  Created by apple on 2022/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消按钮点击事件
typedef void(^cancelBlock)(void);
//确定按钮点击事件
typedef void(^sureBlock)(void);

@interface MLZhuxiaoShowView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;

@property(nonatomic,copy)sureBlock sure_block;

//*  @param title       标题
//*  @param content     内容
//*  @param sure        确定按钮内容
//*  @param sureBlock   确定按钮点击事件

+(instancetype)alterViewWithTitle:(NSString *)title
                         content:(NSString *)content
                            sure:(NSString *)sure
                          cancel:(NSString *)cancel
                      sureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock;

@end


NS_ASSUME_NONNULL_END
