//
//  ML_FocusBottomTableViewCell.h
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AddCellTagBlock) (NSInteger index);

@interface ML_FocusBottomTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property(nonatomic, copy) AddCellTagBlock addCellTagBlock;


@end

NS_ASSUME_NONNULL_END
