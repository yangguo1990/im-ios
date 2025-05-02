//
//  MLHomefocuslistTableViewCell.h
//  miliao
//
//  Created by apple on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickcellButtonBlock) (NSInteger index);

typedef void (^ClickCellVideoBlock)(NSInteger index);

@interface MLHomefocuslistTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property(nonatomic, copy) ClickcellButtonBlock clickbuttonBlock;

@property (nonatomic,copy)ClickCellVideoBlock clickCellVideoBlock;

@end

NS_ASSUME_NONNULL_END
