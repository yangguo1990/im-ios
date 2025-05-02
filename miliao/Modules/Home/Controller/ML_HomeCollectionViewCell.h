//
//  ML_HomeCollectionViewCell.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_HomeCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,strong)UIImageView *isonline;
@property(nonatomic,strong)UIImageView *isking;
@property(nonatomic,strong)UILabel *ageBt;
@property(nonatomic,strong)UIImageView *sexIV;
@property(nonatomic,strong)UIButton *addressBt;
@property(nonatomic,strong)UIImageView *isreal;
@property(nonatomic,strong)UILabel *signLabel;
@property(nonatomic,strong)UIButton *helloBt;
@property(nonatomic,strong)UIButton *dashanBt;
@property(nonatomic,strong)UIImageView* isliveing;
@property(nonatomic,strong)UIImageView* star;
//@property(nonatomic,strong)ML_UserModel *usermodel;
//@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,assign)NSInteger isguanzhu;
@property(nonatomic,assign)NSInteger issearch;
@property(nonatomic,assign)BOOL isId;
@property(nonatomic,assign)BOOL isdong;
@property(nonatomic,strong)UIImageView* opretion;
@property(nonatomic,strong)UIImageView *videoimg;
@end

NS_ASSUME_NONNULL_END
