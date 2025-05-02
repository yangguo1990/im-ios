//
//  ML_NTableViewCell.h
//  SiLiaoBack
//
//  Created by 密码：0000 on 2024/1/7.
//

#import <UIKit/UIKit.h>
#import "ML_UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ML_NTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,strong)UIImageView *isonline;
@property(nonatomic,strong)UIImageView *isking;
@property(nonatomic,strong)UIButton *ageBt;
@property(nonatomic,strong)UILabel *addressBt;
@property(nonatomic,strong)UIImageView *isreal;
@property(nonatomic,strong)UILabel *signLabel;
@property(nonatomic,strong)UIButton *helloBt;
@property(nonatomic,strong)UIButton *dashanBt;
@property(nonatomic,strong)UIImageView* isliveing;
@property(nonatomic,strong)UIImageView* star;
@property(nonatomic,strong)ML_UserModel *usermodel;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,assign)NSInteger isguanzhu;
@property(nonatomic,assign)NSInteger issearch;
@property(nonatomic,assign)BOOL isId;
@property(nonatomic,assign)BOOL isdong;
@property(nonatomic,strong)UIImageView* opretion;
@end

NS_ASSUME_NONNULL_END
