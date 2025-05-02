
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_DuibiCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *dic;
+ (instancetype)ML_cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
