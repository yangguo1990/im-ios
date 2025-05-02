//
//  ExpandLabel.h
//  IosTemplate
//  展开收起YYLabel
//  Created by GuoliWang on 2019/12/10.
//  Copyright © 2019 GuoliWang. All rights reserved.
//

#import "YYLabel.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class ExpandLabel;
@protocol ExpandLabelDelegate <NSObject>
- (void)ExpandLabelClickWei;
@end


typedef void(^ExpandLabelHeightBlock)(CGFloat height);

@interface ExpandLabel : YYLabel

/**用法：1.设置数据
        2.获取控件展开和收起高度
        3.更细控件高度（n行高度）
 **/
- (void)setExpandAtt:(NSString *)text YYLabelW:(CGFloat)YYLabelW MaxLineNum:(NSInteger)maxLineNum font:(UIFont*)font color:(UIColor *)color LineSpace:(CGFloat)lineSpace;



/**  是否展开  */
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, weak) id<ExpandLabelDelegate> delegate;

/**  高度回调  */
@property (nonatomic, copy) ExpandLabelHeightBlock block;
@end

NS_ASSUME_NONNULL_END
