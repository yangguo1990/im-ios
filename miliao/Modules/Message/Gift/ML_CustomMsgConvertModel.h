//
//  ML_CustomMsgConvertModel.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/27.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LVChatScene) {
    LVChatSceneNone = 0,
    LVChatSceneP2P = 1,
};

@class LDSGiftCellModel;
@interface ML_CustomMsgConvertModel : NSObject

+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene withCount:(NSInteger) count withAnimateType:(NSString *) animateType mutiCount:(NSInteger)mutiCount;

//+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene withCount:(NSInteger) count;
//+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withCount:(NSInteger) count;
//+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId;
//
//+ (NIMMessage *)msgWithGiftModel:(LDSGiftCellModel *)giftModel toUserId:(NSString *) userId withScene:(LVChatScene) scene;
//
//+ (NIMMessage *) msgWithTipContent:(NSString *) content;
@end
