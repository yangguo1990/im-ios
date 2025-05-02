//
//  MLDeletDynameView.h
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消按钮点击事件
typedef void(^cancelBlock)(void);
//确定按钮点击事件
typedef void(^sureBlock)(void);

@interface MLDeletDynameView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;

@property(nonatomic,copy)sureBlock sure_block;

+(instancetype)alterViewWithTitle:(NSString *)title
                         content:(NSString *)content
                            sure:(NSString *)sure
                          address:(NSString *)address
                             name:(NSString *)name
                             phone:(NSString *)phone
                             timer:(NSString *)timer
                      sureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock;


@end

NS_ASSUME_NONNULL_END
