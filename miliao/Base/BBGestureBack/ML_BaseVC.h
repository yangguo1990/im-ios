//  希望您的举手之劳，能为我点颗赞，谢谢~
//  代码地址: https://github.com/Bonway/BBGestureBack
//  BBGestureBack
//  Created by Bonway on 2016/3/17.
//  Copyright © 2016年 Bonway. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum _BBPopType {
    BBPopTypeViewController  = 0,
    BBPopTypeToViewController,
    BBPopTypeToRootViewController
} BBPopType;

@interface ML_BaseVC : UIViewController

@property (nonatomic) BBPopType blankType;// default is BBPopTypeViewController.
@property (nonatomic) Boolean isEnablePanGesture;// default is YES.

- (void)bb_popViewController;
- (void)bb_popToViewController:(UIViewController *)viewController;
- (void)bb_popToRootViewController;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *ML_TableView;
@property (nonatomic, strong) UIImageView *ML_bgImageView;
@property (nonatomic, strong) UILabel *ML_titleLabel;
@property (nonatomic, strong) UIView *ML_navView;
@property (nonatomic, strong) UIView *ML_navAlphaView;
@property (nonatomic, strong) UIButton *ML_backBtn;
@property (nonatomic, strong) UIButton *ML_rightBtn;
- (void)HY_addTableView;
- (void)ML_setUpCustomNavklb_la;
- (void)ML_backClickklb_la;
- (void)ML_addNavRightBtnWithTitle:(NSString *)title image:(UIImage *)image;
- (void)ML_rightItemClicked;
- (void)ML_addCollectionView;
//- (void)ML_addEndTap;
- (void)ML_getNetwork:(NSString *)str isPop:(BOOL)isP;
//- (void)addKongBGUI;
- (void)removeKongView;


@end


@interface BBGestureBaseView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *NmaskView;
@property (nonatomic, strong) NSMutableArray *arrayImage;

- (void)showEffectChange:(CGPoint)pt;
- (void)restore;
- (void)screenShot;
- (void)removeObserver;
- (void)addObserver;
@end
