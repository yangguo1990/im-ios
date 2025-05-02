//
//  MLMineTextViewTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLMineTextViewTableViewCell : UITableViewCell

@property(nonatomic,copy) void (^textviewStrBlock)(NSString *textViewStr);
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *indextitlelabel;

@end

NS_ASSUME_NONNULL_END
