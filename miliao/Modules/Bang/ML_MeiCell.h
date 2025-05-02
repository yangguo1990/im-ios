
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM (NSInteger,CityUITableViewCell){
//    CityUITableViewCellcity,
//    CityUITableViewCellfocus
//};

typedef void (^ClickcellCityButtonBlock) (NSDictionary *btn);

typedef void (^ClickCellVideoBlock)(NSInteger index);


@interface ML_MeiCell : UITableViewCell
//
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int way;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIButton *dashanbtn;


@property(nonatomic, copy) ClickcellCityButtonBlock clickcellCityButtonBlock;

@property (nonatomic,copy)ClickCellVideoBlock clickCellVideoBlock ;



@end

NS_ASSUME_NONNULL_END
