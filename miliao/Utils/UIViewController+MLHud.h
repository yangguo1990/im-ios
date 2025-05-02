//
//  UIViewController+MLHud.h
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MLHud)


-(void)showSuccess:(NSString *)success;
-(void)showError:(NSString *)error;
-(void)showMessage:(NSString *)message;
-(void)showWaiting;
-(void)showLoading;
-(void)showLoadingWithMessage:(NSString *)message;
-(void)showSaving;
-(void)hideHUD;
-(void)showtopMessage:(NSString *)topmessage topview:(UIView *)topview;

@end

NS_ASSUME_NONNULL_END
