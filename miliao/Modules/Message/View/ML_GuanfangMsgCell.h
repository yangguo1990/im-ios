
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_GuanfangMsgCell : UITableViewCell
@property (nonatomic ,copy) void (^RefreshContenBlock)(NSDictionary *model);
@property (nonatomic, strong) NSDictionary *ML_Model;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isZhan;
+ (instancetype)ML_cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
