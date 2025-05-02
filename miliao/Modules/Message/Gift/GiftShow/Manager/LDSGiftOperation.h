//
//  LDSGiftOperation.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LDSGiftModel,LDSGiftShowView;
typedef void(^completeOpBlock)(BOOL finished,NSString *giftKey);
@interface LDSGiftOperation : NSOperation

/**
 增加一个操作

 @param giftShowView 礼物显示的View
 @param backView 礼物要显示在的父view
 @param model 礼物的数据
 @param completeBlock 回调操作结束
 @return 操作
 */
+ (instancetype)addOperationWithView:(LDSGiftShowView *)giftShowView
                              OnView:(UIView *)backView
                                Info:(LDSGiftModel *)model
                       completeBlock:(completeOpBlock)completeBlock;


/** 礼物展示的父view */
@property(nonatomic,strong) UIView *backView;
/** model */
@property(nonatomic,strong) LDSGiftModel *model;

/** block */
@property(nonatomic,copy) completeOpBlock opFinishedBlock;
/** showview */
@property(nonatomic,strong) LDSGiftShowView *giftShowView;

@end
