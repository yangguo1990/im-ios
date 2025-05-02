//
//  ML_HostMessageTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_HostMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic,strong) UILabel *tnameLabel;
@property (nonatomic,strong) UIButton *bb;

@end

NS_ASSUME_NONNULL_END
