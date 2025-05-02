//
//  MLFabuSelectCollectionViewCell.h
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import <UIKit/UIKit.h>

//取消按钮点击事件
typedef void(^cancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MLFabuSelectCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIImageView *delectimg;

@property(nonatomic,copy)cancelBlock cancel_block;

@end

NS_ASSUME_NONNULL_END
