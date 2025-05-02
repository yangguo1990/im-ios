//
//  LDSGiftShowView.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <UIKit/UIKit.h>

@class LDSGiftModel;
typedef void(^completeShowViewBlock)(BOOL finished,NSString *giftKey);
typedef void(^completeShowViewKeyBlock)(LDSGiftModel *giftModel);
@interface LDSGiftShowView : UIView

/**
 展示礼物动效

 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 */
- (void)showGiftShowViewWithModel:(LDSGiftModel *)giftModel
                    completeBlock:(completeShowViewBlock)completeBlock;

/** 一次进来的礼物数 */
@property(nonatomic,assign) NSInteger giftCount;
/** 当前礼物总数 */
@property(nonatomic,assign) NSInteger currentGiftCount;
/** block */
@property(nonatomic,copy) completeShowViewBlock showViewFinishBlock;
/** 返回当前礼物的唯一key */
@property(nonatomic,copy) completeShowViewKeyBlock showViewKeyBlock;
/** model */
@property(nonatomic,strong) LDSGiftModel *finishModel;

@end

