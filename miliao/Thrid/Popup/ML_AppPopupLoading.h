//
//  ML_AppPopupLoading.h
//  WorkplaceApppPopupDemo
//
//  Created by zhutaofeng on 2019/5/13.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ML_AppPopupConst.h"

@class ML_AppPopupLoading;
typedef void(^ML_AppPopupLoadingBlock)(ML_AppPopupLoading *toast);

@interface ML_AppPopupLoading : UIView

@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic,strong)UILabel  *msgLabel;

+(void)tf_show:(UIView *)inView animationType:(TFAnimationType)animationType;
+(void)tf_hide:(UIView *)inView;

@end


