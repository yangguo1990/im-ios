//
//  ML_TixianWayCollectionViewCell.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import <UIKit/UIKit.h>
#import "ML_chongPayView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ML_TixianWayCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *withDrawIcon;
@property(nonatomic,strong)UILabel *withDrawName;
@property(nonatomic,strong)UILabel *withDrawinfo;
@property(nonatomic,strong)UIButton *bindBT;
@property(nonatomic,strong)UIImageView *selectIV;
@property(nonatomic,weak)ML_chongPayView *payView;
@property(nonatomic,assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
