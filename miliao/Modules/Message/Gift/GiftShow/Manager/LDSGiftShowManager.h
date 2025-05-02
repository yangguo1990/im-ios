//
//  LDSGiftShowManager.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <UIKit/UIKit.h>

@class LDSGiftModel;
typedef void(^completeBlock)(BOOL finished);

@interface LDSGiftShowManager : NSObject

+ (instancetype)shareInstance;

/**
 送礼物(不处理第一次展示当前礼物逻辑)
 
 @param backView 礼物动效展示父view
 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 */

- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(LDSGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock;

@end
