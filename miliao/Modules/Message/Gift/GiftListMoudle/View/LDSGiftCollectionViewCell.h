//
//  LDSGiftCollectionViewCell.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LDSGiftCellModel;
@interface LDSGiftCollectionViewCell : UICollectionViewCell

/** model */
@property(nonatomic,strong) LDSGiftCellModel *model;
/** bg */
@property(nonatomic,strong) UIView *bgView;
@end

NS_ASSUME_NONNULL_END
