//
//  UIScrollView+WorkplaceApppPopup.h
//  WorkplaceApppPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "ML_AppPopupConst.h"
#import "NSObject+TFPopupMethodExchange.h"

@interface UIScrollView (WorkplaceApppPopup)<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property(nonatomic,  weak) UIView *faterPopupView;

@end


