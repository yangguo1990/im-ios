//
//  MLFabuAddrListViewController.h
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnTextBlock)(NSString * showText);


@interface MLFabuAddrListViewController : ML_BaseVC

@property (nonatomic,copy)ReturnTextBlock returntextBlock;
@end

NS_ASSUME_NONNULL_END
