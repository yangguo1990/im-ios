//
//  FriendTableViewCell.h
//  facetest
//
//  Created by apple on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^AddcellBlock) (void);

@interface FriendTableViewCell : UITableViewCell

@property(nonatomic, copy) AddcellBlock addToCartsBlock;
@property(nonatomic,assign)BOOL isChecked;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
