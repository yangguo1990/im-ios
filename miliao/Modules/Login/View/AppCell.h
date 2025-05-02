//
//  AppCell.h
//  facetest
//
//  Created by apple on 2022/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic,strong)NSDictionary *dict;



@end

NS_ASSUME_NONNULL_END
