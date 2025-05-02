//
//  CMVideoRecordView.h
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CMVideoRecordDismissBlock)(void);
typedef void(^CMVideoRecordVideoCompletionBlock)(NSURL *fileUrl);
typedef void(^CMVideoRecordPhotoCompletionBlock)(UIImage *image);

@interface CMVideoRecordView : ML_BaseVC

/**
 取消回调
 */
@property (nonatomic, copy) CMVideoRecordDismissBlock cancelBlock;

/**
 拍摄视频完成回调
 */
@property (nonatomic, copy) CMVideoRecordVideoCompletionBlock videoCompletionBlock;

/**
 拍摄图片完成回调
 */
@property (nonatomic, copy) CMVideoRecordPhotoCompletionBlock photoCompletionBlock;

@end

NS_ASSUME_NONNULL_END
