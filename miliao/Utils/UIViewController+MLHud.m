//
//  UIViewController+MLHud.m
//  miliao
//
//  Created by apple on 2022/9/28.
//

#import "UIViewController+MLHud.h"
#import <Colours/Colours.h>

@implementation UIViewController (MLHud)

-(void)showSuccess:(NSString *)success
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=MBProgressHUDModeText;
    HUD.label.text=success;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}
-(void)showError:(NSString *)error
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=MBProgressHUDModeText;
    HUD.label.text=error;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}
-(void)showMessage:(NSString *)message
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.layer.cornerRadius =  20;
    HUD.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7000];
    HUD.mode=MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    HUD.margin = 13;//修改该值，可以修改加载框大小

    HUD.label.text = message;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.2];
}

-(void)showtopMessage:(NSString *)topmessage topview:(UIView *)topview{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:topview];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.layer.cornerRadius =  20;
    HUD.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7000];
    HUD.mode=MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    HUD.margin = 13;//修改该值，可以修改加载框大小

    HUD.label.text = topmessage;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.removeFromSuperViewOnHide=YES;
    [topview addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.2];
}


-(void)showWaiting
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
}
-(void)showLoading
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=@"正在加载";
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
}
-(void)showLoadingWithMessage:(NSString *)message
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=message;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
}
-(void)showSaving
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=@"正在保存";
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
}
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:[self getView] animated:YES];
}
-(UIView *)getView
{
    UIView *view;
    if (self.navigationController.view) {
        view=self.navigationController.view;
    }else
    {
        view=self.view;
    }
    return view;
}




@end
