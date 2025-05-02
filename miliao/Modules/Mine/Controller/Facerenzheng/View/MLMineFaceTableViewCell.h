//
//  MLMineFaceTableViewCell.h
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger,MLMineFaceTableViewCellFace){
    MLMineFaceTableViewCellface,
    MLMineFaceTableViewCellhost
};

@interface MLMineFaceTableViewCell : UITableViewCell

@property (nonatomic,assign)MLMineFaceTableViewCellFace type;

@end

NS_ASSUME_NONNULL_END
