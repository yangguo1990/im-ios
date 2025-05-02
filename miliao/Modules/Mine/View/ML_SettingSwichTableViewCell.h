//
//  ML_SettingSwichTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SwichBlock)(NSInteger index,UIButton *btn);

@interface ML_SettingSwichTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,copy)SwichBlock swichBlock;
@property (nonatomic,strong)UIButton *setnetbtn;
@property (nonatomic,strong)UIImageView *selectimg;


@end

NS_ASSUME_NONNULL_END
