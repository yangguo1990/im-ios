//
//  UIView+ML_Additions.h
//  miliao
//
//  Created by apple on 2022/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ML_Additions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
 
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat framewidth;
@property (nonatomic) CGFloat height;
 
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
 
@property (nonatomic,readonly) CGFloat screenX;
@property (nonatomic,readonly) CGFloat screenY;
@property (nonatomic,readonly) CGFloat screenViewX;
@property (nonatomic,readonly) CGFloat screenViewY;
@property (nonatomic,readonly) CGRect screenFrame;


@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
 
@property (nonatomic) BOOL visible;
 
/**
  * Finds the first descendant view (including this view) that is a member of a particular class.
  */
- (UIView*)descendantOrSelfWithClass:(Class)cls;
 
/**
  * Finds the first ancestor view (including this view) that is a member of a particular class.
  */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;
 
/**
  * Removes all subviews.
  */
- ( void )removeAllSubviews;
 
 
/**
  * Calculates the offset of this view from another view in screen coordinates.
  */
- (CGPoint)offsetFromView:(UIView*)otherView;
 
 
/**
  * The view controller whose view contains this view.
  */
- (UIViewController*)viewController;
 
 
- ( void )addSubviews:(NSArray *)views;



@end

NS_ASSUME_NONNULL_END
