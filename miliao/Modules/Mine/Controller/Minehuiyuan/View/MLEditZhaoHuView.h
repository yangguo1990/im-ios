//
//  MLEditZhaoHuView.h
//  miliao
//
//  Created by apple on 2022/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消按钮点击事件
typedef void(^cancelBlock)(void);
//确定按钮点击事件
typedef void(^sureBlock)(void);

typedef void(^textviewStrBlock)(NSString *textViewStr);


@interface MLEditZhaoHuView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;

@property(nonatomic,copy)sureBlock sure_block;

@property(nonatomic,copy)textviewStrBlock textviewStrblock;


//*  @param title       标题
//*  @param content     内容
//*  @param sure        确定按钮内容
//*  @param sureBlock   确定按钮点击事件

+(instancetype)alterVietextviewStrblock:(textviewStrBlock)textviewStrblock
                        lengthstr:(NSString *)lengthstr
                       textView:(NSString *)textView
                      sureBtClcik:(sureBlock)sureBlock
                            cancelClick:(cancelBlock)cancelBlock;


@end

NS_ASSUME_NONNULL_END
