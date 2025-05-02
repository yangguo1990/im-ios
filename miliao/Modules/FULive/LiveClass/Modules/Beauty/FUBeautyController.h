//
//  FUBeautyController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyController : FUBaseViewController
@property (nonatomic ,assign) BOOL isAppearance; //是否颜值
@property (nonatomic ,copy) void (^cameraBlock)(NSString * headerUrl);
@end

NS_ASSUME_NONNULL_END
