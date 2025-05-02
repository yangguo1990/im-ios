//
//  ML_MinegexingTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_MinegexingTableViewCell : UITableViewCell

@property(nonatomic,copy) void (^textviewStrBlock)(NSString *textViewStr);
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIView *liveV;

@end

NS_ASSUME_NONNULL_END
