//
//  TestViewController.h
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ML_BaseVC.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"

#define WindowsSize [UIScreen mainScreen].bounds.size

@interface ML_MyBillVC : ML_BaseVC <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

@property (nonatomic, assign) BOOL shouldHandleScreenEdgeGesture;

- (JXCategoryBaseView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index;

@end
