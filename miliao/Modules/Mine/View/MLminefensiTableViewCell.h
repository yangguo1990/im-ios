//
//  MLminefensiTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import <UIKit/UIKit.h>

typedef void (^ClickcellButtonBlock) (NSInteger index,UIButton * _Nonnull btn);

typedef void (^ClickCellVideoBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MLminefensiTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)NSDictionary *dict;

@property(nonatomic, copy) ClickcellButtonBlock clickbuttonBlock;

@property (nonatomic,copy)ClickCellVideoBlock clickCellVideoBlock;



@end

NS_ASSUME_NONNULL_END
