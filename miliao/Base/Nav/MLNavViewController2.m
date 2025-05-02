//
//  MLNavViewController.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "MLNavViewController2.h"

@interface MLNavViewController2 ()

@end

@implementation MLNavViewController2

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}
//
- (void)viewDidLoad {
    [super viewDidLoad];
   
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0f green:51/255.0f  blue:51/255.0f  alpha:1]};
//       UINavigationBar *navBar = [UINavigationBar appearance];
//     UIColor *color =  [UIColor colorWithRed:255/255.0f green:255/255.0f  blue:255/255.0f  alpha:1];
//       navBar.barTintColor = color;
//      [navBar setShadowImage:[UIImage new]];

    
    self.interactivePopGestureRecognizer.enabled = NO;
}
//
//
////重写跳转
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//      //隐藏地步tabar
//      if (self.childViewControllers.count > 0){//即将跳往二级界面
//          UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//          [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateNormal];
//          [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateHighlighted];
//          [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//          [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//          [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//          [backButton sizeToFit];
//          backButton.frame= CGRectMake(0, 0, 46,46);
//          backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//          // 设置返回按钮
//          viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//          viewController.hidesBottomBarWhenPushed = YES;
//      }
//    
//    [super pushViewController:viewController animated:animated];
//}
//
//
//
///**重写Pop方法*/
//-(NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"viewController9999----%@",viewController);
//    for (NSInteger i = self.viewControllers.count-1; i>0; i--) {
//        if (viewController == self.viewControllers[i]) {
//            break;
//        }
//    }
//    return [super popToViewController:viewController animated:animated];
//}
//
///**重写Pop方法*/
//-(NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    
//    //回到了根视图，移除所有截图
//    return [super popToRootViewControllerAnimated:animated];
//}
//
//
//-(void)back{
//    [self popViewControllerAnimated:YES];
//}
//
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
//        return;
//    }
//    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
//        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
//            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
//            if (obj.frame.size.width < 42){
//                [viewController.view sendSubviewToBack:obj];
//                *stop = YES;
//            }
//        }];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
