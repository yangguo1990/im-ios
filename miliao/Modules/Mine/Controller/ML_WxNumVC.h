//
//  MLMineNmaechangeViewController.h
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnTextBlock)(NSString * showText);
@interface ML_WxNumVC : ML_BaseVC

@property (nonatomic,copy)ReturnTextBlock returnBlock;
@end

NS_ASSUME_NONNULL_END
