//
//  UIViewController+CurrentShowVC.m
//  LiveVideo
//
//  Created by 史贵岭 on 2017/5/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "UIViewController+CurrentShowVC.h"
#import "RDVTabBarController.h"

@implementation UIViewController (CurrentShowVC)
- (UIViewController *)topShowViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else if ([vc isKindOfClass:[RDVTabBarController class]]){
        return [self _topViewController:[(RDVTabBarController *)vc selectedViewController]];
    }
    else {
        return vc;
    }
    return nil;
}

+ (UIViewController *)topShowViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;

}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else if ([vc isKindOfClass:[RDVTabBarController class]]){
        return [self _topViewController:[(RDVTabBarController *)vc selectedViewController]];
    }
    else {
        return vc;
    }
    return nil;
}
@end
