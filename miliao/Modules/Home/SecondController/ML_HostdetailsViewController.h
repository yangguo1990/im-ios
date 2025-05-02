//
//  ML_HostdetailsViewController.h
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_HostdetailsViewController : ML_BaseVC
@property (nonatomic,strong)NSDictionary *dict;
- (instancetype)initWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
