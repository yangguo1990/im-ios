
#import <UIKit/UIKit.h>
#import "ExpandLabel.h"
#import "ML_PictureCell.h"
#import "UIView+ML.h"
#import "NSObject+ML.h"
@class ML_CommunityModel;
NS_ASSUME_NONNULL_BEGIN

@interface ML_CommunityCell : UITableViewCell

@property (nonatomic, strong) NSArray *ML_ListArr;
@property (nonatomic, strong) ML_CommunityModel *ML_Model;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic ,copy) void (^RefreshContenBlock)(ML_CommunityModel *model);
@property (nonatomic ,copy) void (^ToastPictureVCBlock)(ML_CommunityModel *blockModel, UIView *collView, int type);

@property (strong, nonatomic) UIImageView *ML_AvImgV;
@property (strong, nonatomic) UILabel *ML_Name;
@property (strong, nonatomic) UIButton *ML_LoveBtn;
@property (strong, nonatomic) ExpandLabel *contentTextView;
@property (strong, nonatomic) UIView *ML_Linve;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong)UIImageView *sexIV;
@property (nonatomic,strong)CALayer *gradLayer;
@property (nonatomic,strong)UILabel *onlineLabel;
@property (nonatomic,strong)UIButton *shipBt;
+ (instancetype)ML_cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
