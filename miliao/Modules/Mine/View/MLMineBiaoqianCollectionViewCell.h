//
//  MLMineBiaoqianCollectionViewCell.h
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnTextBlock)(UILabel * showText,UIView *bgview);


@interface MLMineBiaoqianCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIView *bgview;

@property (nonatomic,copy)ReturnTextBlock returnBlock;

@end

NS_ASSUME_NONNULL_END
