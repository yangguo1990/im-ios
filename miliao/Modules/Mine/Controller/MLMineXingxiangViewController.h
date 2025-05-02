//
//  MLMineXingxiangViewController.h
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnArrayBlock)(NSArray * bianqianArray, NSMutableArray *idArr);

@interface MLMineXingxiangViewController : ML_BaseVC

@property (nonatomic,strong)NSMutableArray *labelArray;
@property (nonatomic,strong)NSMutableArray *dataid;

@property (nonatomic,copy) ReturnArrayBlock returnBlock;


@end

NS_ASSUME_NONNULL_END
