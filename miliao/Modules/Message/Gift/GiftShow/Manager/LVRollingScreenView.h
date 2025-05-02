//
//  LVRollingScreenView.h
//  LiveSendGift
//
//  Created by 史贵岭 on 2018/1/29.
//  Copyright © 2018年 com.wujh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDSGiftModel.h"

@interface LVRollingScreenView : UIView

+ (instancetype)sharedRollingScreenView;
- (void) startShowGiftViewWithBigGiftModel:(LDSGiftModel *) giftModel;
- (void)removeView;
@end
