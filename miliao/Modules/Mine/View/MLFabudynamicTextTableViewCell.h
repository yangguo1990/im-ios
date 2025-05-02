//
//  MLFabudynamicTextTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLFabudynamicTextTableViewCell : UITableViewCell

@property(nonatomic,copy) void (^textviewStrBlock)(NSString *textViewStr);
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UITextView *textView;


@end

NS_ASSUME_NONNULL_END
