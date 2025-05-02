//
//  MLMineDynameTableViewCell.h
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger,DynameTableViewCell){
    DynameUITableViewCellone,
    DynameUITableViewCelltwo,
    DynameUITableViewCellthree,
    DynameUITableViewCellfour
};

@interface MLMineDynameTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,assign)DynameTableViewCell type;

@property (nonatomic,strong)UILabel *statuslabel;




@end

NS_ASSUME_NONNULL_END
