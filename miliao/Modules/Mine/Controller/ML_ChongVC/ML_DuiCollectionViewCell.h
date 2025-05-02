//
//  ML_DuiCollectionViewCell.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_DuiCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
