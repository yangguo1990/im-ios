
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionViewController.h"

@interface ML_TonghuaListVC : ML_BaseVC

@property (nonatomic ,copy) void (^RefreshContenBlock)(BOOL isHi);
@property (nonatomic,strong) UILabel *titleLabel;
- (void)setUpNavItem;

@end
