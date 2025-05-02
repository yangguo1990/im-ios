//
//  MLHomeSearchTableViewCell.h
//  miliao
//
//  Created by apple on 2022/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TermCellDelegate <NSObject>

- (void)choseTerm:(UIButton *)button index:(NSInteger)index;

@end


@interface MLHomeSearchTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property (assign, nonatomic) id<TermCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
