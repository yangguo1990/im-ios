//
//  MLFriendTableViewCell.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AddcellBlock) (void);

@interface MLFriendTableViewCell : UITableViewCell

@property(nonatomic, copy) AddcellBlock addToCartsBlock;
@property(nonatomic,assign)BOOL isChecked;

@end

NS_ASSUME_NONNULL_END
