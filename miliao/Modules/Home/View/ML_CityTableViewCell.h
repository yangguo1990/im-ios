//
//  ML_CityTableViewCell.h
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger,CityUITableViewCell){
    CityUITableViewCellcity,
    CityUITableViewCellfocus
};

typedef void (^ClickcellCityButtonBlock) (UIButton *btn);

typedef void (^ClickCellVideoBlock)(NSInteger index);


@interface ML_CityTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,assign)CityUITableViewCell type;

@property (nonatomic,strong)UIButton *dashanbtn;


@property(nonatomic, copy) ClickcellCityButtonBlock clickcellCityButtonBlock;

@property (nonatomic,copy)ClickCellVideoBlock clickCellVideoBlock ;



@end

NS_ASSUME_NONNULL_END
