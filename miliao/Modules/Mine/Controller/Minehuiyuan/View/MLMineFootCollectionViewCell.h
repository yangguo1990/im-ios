//
//  MLMineFootCollectionViewCell.h
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLMineFootCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign)BOOL isChecked;
@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *selectimgView;
@property  (nonatomic,strong)UIImageView *topimgView;

@end

NS_ASSUME_NONNULL_END
