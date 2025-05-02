//
//  UIViewController+CurrentShowVC.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ML_BaseVC.h"

@interface UIViewController (CurrentShowVC)
- (UIViewController *)topShowViewController;

+ (UIViewController *)topShowViewController;
@end
