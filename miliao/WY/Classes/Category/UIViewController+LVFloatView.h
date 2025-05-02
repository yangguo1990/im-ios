//
//  UIViewController+LVFloatView.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/8/29.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LVFloatView)
@property(nonatomic,assign) NSInteger lvDisturbViewHeight;

-(void) showDisturbFloatView;
-(void) hideDistrubFloatView;

-(void) lvDirectOpenAcceptCall;
@end
