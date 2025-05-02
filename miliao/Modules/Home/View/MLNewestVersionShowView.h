//
//  MLNewestVersionShowView.h
//  miliao
//
//  Created by apple on 2022/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消按钮点击事件
typedef void(^cancelBlock)(void);
//确定按钮点击事件
typedef void(^sureBlock)(void);

typedef void(^userBlock)(void);
typedef void(^agreetBlock)(void);
typedef void(^phoneBlock)(void);


typedef void(^textviewStrBlock)(NSString *textViewStr);



@interface MLNewestVersionShowView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;

@property(nonatomic,copy)sureBlock sure_block;


@property(nonatomic,copy)userBlock user_block;
@property(nonatomic,copy)agreetBlock agreet_block;
@property(nonatomic,copy)phoneBlock phone_block;



@property(nonatomic,copy)textviewStrBlock textviewStrblock;


//@property(nonatomic,copy) void (^textviewStrBlock)(NSString *textViewStr);


//*  @param title       标题
//*  @param content     内容
//*  @param sure        确定按钮内容
//*  @param sureBlock   确定按钮点击事件

+(instancetype)alterVietextview:(NSString *)textview must:(BOOL)must
                       namestr:(NSString *)namestr
            StrblocksureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock;



@end

NS_ASSUME_NONNULL_END
