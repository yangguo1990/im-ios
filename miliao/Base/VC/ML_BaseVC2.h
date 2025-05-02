// lin
#import <UIKit/UIKit.h>

@interface ML_BaseVC2 : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *ML_TableView;
@property (nonatomic, strong) UIImageView *ML_bgImageView;
@property (nonatomic, strong) UILabel *ML_titleLabel;
@property (nonatomic, strong) UIView *ML_navView;
@property (nonatomic, strong) UIButton *ML_backBtn;
@property (nonatomic, strong) UIButton *ML_rightBtn;
- (void)HY_addTableView;
- (void)ML_setUpCustomNavklb_la;
- (void)ML_backClickklb_la;
- (void)ML_addNavRightBtnWithTitle:(NSString *)title image:(UIImage *)image;
- (void)ML_rightItemClicked;
- (void)ML_addCollectionView;
- (void)ML_addEndTap;
- (void)ML_getNetwork:(NSString *)str isPop:(BOOL)isP;
- (void)addKongBGUI;
- (void)removeKongView;
@end

