//
//  MLMineZhaohuSetTableViewCell.h
//  miliao
//
//  Created by apple on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TermCellDelegate <NSObject>
  
- (void)choseTerm:(UIButton *)button index:(NSInteger)index;
  
@end


@interface MLMineZhaohuSetTableViewCell : UITableViewCell

@property (assign, nonatomic) id<TermCellDelegate> delegate;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)NSString *conStr;

@property (nonatomic,strong)UIButton *zhidingbtn;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UILabel *label;

@end

NS_ASSUME_NONNULL_END
