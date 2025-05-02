//
//  ML_MineSexSelectTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^TopTextBlock)(void);
typedef void (^BottomTextBlock)(void);


@interface ML_MineSexSelectTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *bottomtitlelabel;
@property (nonatomic,strong)UILabel *titlelabel;

@property (nonatomic,strong)UILabel *bottomsubtitlelabel;
@property (nonatomic,strong)UILabel *subtitlelabel;


@property (nonatomic,copy)TopTextBlock topBlock;
@property (nonatomic,copy)BottomTextBlock bottomBlock;

@property (nonatomic,strong)UIImageView *bottomselectimg;


@end

NS_ASSUME_NONNULL_END
