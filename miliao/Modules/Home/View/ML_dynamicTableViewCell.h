//
//  ML_dynamicTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ML_dynamicTableViewCell;

typedef void (^ClickcellButtonBlock) (NSInteger index, UIButton *btn);

typedef void (^ClickCellVideoBlock)(NSInteger index);

@interface ML_dynamicTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,strong)UILabel *nameLabel;
@property(nonatomic, copy) ClickcellButtonBlock clickbuttonBlock;

@property (nonatomic,copy)ClickCellVideoBlock clickCellVideoBlock ;


@end

NS_ASSUME_NONNULL_END
