//
//  MLKaitongPayViewController.h
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLKaitongPayViewController : ML_BaseVC

@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,assign)BOOL appleType;
@property (nonatomic,strong) NSArray *appleArr;
@property (nonatomic,assign) NSInteger page;


@property (nonatomic, assign) BOOL wxPay;              //
@property (nonatomic, assign) BOOL aliPay;              //
@property (nonatomic, assign) BOOL cardPay;              //
@property (nonatomic, strong)NSArray *paylist;

@end

NS_ASSUME_NONNULL_END
