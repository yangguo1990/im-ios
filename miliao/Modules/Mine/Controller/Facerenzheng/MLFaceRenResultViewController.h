//
//  MLFaceRenResultViewController.h
//  miliao
//
//  Created by apple on 2022/9/28.

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLFaceRenResultViewController : ML_BaseVC


@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,copy)NSString *idcardestr;
@property (nonatomic,copy)NSString *certifyId;

@property (nonatomic,copy)NSString *result;
@property (nonatomic,copy)NSString *msg;

@end

NS_ASSUME_NONNULL_END
