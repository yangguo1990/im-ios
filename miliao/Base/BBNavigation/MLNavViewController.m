//  希望您的举手之劳，能为我点颗赞，谢谢~
//  代码地址: https://github.com/Bonway/BBGestureBack
//  BBGestureBack
//  Created by Bonway on 2016/3/17.
//  Copyright © 2016年 Bonway. All rights reserved.
//

#import "MLNavViewController.h"
#import "MLLoginViewController.h"
#import "BBGestureBack.h"
#import "AppDelegate.h"
#import "ML_MineEditViewController.h"
#import "MLFabuDynamicViewController.h"

@interface MLNavViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@end

@implementation MLNavViewController


//重写跳转
- (void)pushOtherVC:(UIViewController *)viewController animated:(BOOL)animated{
      //隐藏地步tabar
      if (self.childViewControllers.count > 0){//即将跳往二级界面
          UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
          [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateNormal];
          [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateHighlighted];
          [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
          [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
          [backButton sizeToFit];
          backButton.frame= CGRectMake(0, 0, 46,46);
          backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
          // 设置返回按钮
          viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
          viewController.hidesBottomBarWhenPushed = YES;
      }

    [super pushViewController:viewController animated:animated];
}



/**重写Pop方法*/
//-(NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"viewController9999----%@",viewController);
//    for (NSInteger i = self.viewControllers.count-1; i>0; i--) {
//        if (viewController == self.viewControllers[i]) {
//            break;
//        }
//    }
//    return [super popToViewController:viewController animated:animated];
//}

/**重写Pop方法*/
//-(NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//
//    //回到了根视图，移除所有截图
//    return [super popToRootViewControllerAnimated:animated];
//}


-(void)back{
    [self popViewControllerAnimated:YES];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42){
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}


-(NSMutableArray *)arrayScreenshot{
    if (!_arrayScreenshot) {
        _arrayScreenshot = [NSMutableArray array];
    }
    return _arrayScreenshot;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //屏蔽系统的手势
//    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = !kBBIsCanleSystemPan;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view && [gestureRecognizer locationInView:self.view].x < (kBBDistanceToStart == 0 ? UIScreen.mainScreen.bounds.size.width : kBBDistanceToStart)) {
        ML_BaseVC *topView = (ML_BaseVC *)self.topViewController;
        
        if (![topView isKindOfClass:[ML_BaseVC class]]) {
            return NO;
        }
        
        
        if (!topView.isEnablePanGesture)
            return NO;
        else {
            CGPoint translate = [gestureRecognizer translationInView:self.view];
            BOOL possible = translate.x != 0 && fabs(translate.y) == 0;
            if (possible)
                return YES;
            else
                return NO;
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]|| [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        UIView *aView = otherGestureRecognizer.view;
        if ([aView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (UIScrollView *)aView;
            if (sv.contentOffset.x==0) {
                if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] && otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
        return NO;
    }
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    NSLog(@"dsf=adsf==%d", self.viewControllers.count);
    
//    if ([[UIViewController topShowViewController] isKindOfClass:[ML_MineEditViewController class]] ||
//        [[UIViewController topShowViewController] isKindOfClass:[MLFabuDynamicViewController class]]) {
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tanBack"  object:nil];
//        
//        return;
//    }

    
    UIViewController *vc = [UIViewController topShowViewController].tabBarController;
    if (!vc && self.viewControllers.count == 2) {
        return;
    }
    
    
    if (self.viewControllers.count == 1) {
        return;
    }
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (BBIS_IPHONEX && kBBIsOpenIphoneXStyle) {
            rootVC.view.layer.masksToBounds = YES;
            rootVC.view.layer.cornerRadius = kBBIphoneXStyleCorner;
            presentedVC.view.layer.masksToBounds = YES;
            presentedVC.view.layer.cornerRadius = kBBIphoneXStyleCorner;
        }
        appDelegate.gestureBaseView.hidden = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= kBBDistanceToPan) {
            rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - kBBDistanceToPan, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - kBBDistanceToPan, 0);
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= kBBDistanceToLeft) {
            [UIView animateWithDuration:kBBGestureSpeed animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appDelegate.gestureBaseView.hidden = YES;
            }];
        }
        else {
            [UIView animateWithDuration:kBBGestureSpeed animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (BBIS_IPHONEX && kBBIsOpenIphoneXStyle) {
                    rootVC.view.layer.masksToBounds = NO;
                    rootVC.view.layer.cornerRadius = 0;
                    presentedVC.view.layer.masksToBounds = NO;
                    presentedVC.view.layer.cornerRadius = 0;
                }
                appDelegate.gestureBaseView.hidden = YES;
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
 
    ML_BaseVC *topView = (ML_BaseVC *)self.topViewController;
    
    if (![topView isKindOfClass:[ML_BaseVC class]]) {
        return YES;
    }
    
    if ([topView isKindOfClass:[ML_BaseVC class]]) {
        if (topView.isEnablePanGesture == NO)     return NO;
        if (self.viewControllers.count <= 1)    return NO;
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            CGPoint point = [touch locationInView:gestureRecognizer.view];
            if (point.x < [UIScreen mainScreen].bounds.size.width) {
                
                return YES;
            }
        }
    } else {
        
    }

    return NO;
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *arr = [super popToViewController:viewController animated:animated];
    if (self.arrayScreenshot.count > arr.count){
        for (int i = 0; i < arr.count; i++) {
            [self.arrayScreenshot removeLastObject];
        }
    }
    return arr;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (!self.viewControllers) {
        return;
    }
    
    UIViewController *vc = self.viewControllers.firstObject.tabBarController;
    
    if (![viewController isKindOfClass:[ML_BaseVC class]] || !vc) {
        [self pushOtherVC:viewController animated:animated];

    }  else {
        
        if (self.viewControllers.count == 0) {
            return [super pushViewController:viewController animated:animated];
        }else if (self.viewControllers.count >= 1) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.frame.size.width, appdelegate.window.frame.size.height), YES, 0);
        [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.arrayScreenshot addObject:viewImage];
        appdelegate.gestureBaseView.imgView.image = viewImage;
        [super pushViewController:viewController animated:animated];
    }
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.arrayScreenshot removeLastObject];
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        appdelegate.gestureBaseView.imgView.image = image;
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
    return viewController;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.arrayScreenshot.count > 2) {
        [self.arrayScreenshot removeObjectsInRange:NSMakeRange(1, self.arrayScreenshot.count - 1)];
    }
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        appdelegate.gestureBaseView.imgView.image = image;
    return [super popToRootViewControllerAnimated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
