//
//  ML_editeImageCollectionViewCell.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_editeImageCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)UIButton *shanBt;
@property(nonatomic,strong)UIButton *fengBt;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *fengLabel;
@property(nonatomic,copy)void(^cellBolock)(void);
@end

NS_ASSUME_NONNULL_END
